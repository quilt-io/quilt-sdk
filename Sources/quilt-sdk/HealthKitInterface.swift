//
//  File.swift
//  
//
//  Created by Jessica Petrochuk on 7/6/23.
//

import Foundation
import HealthKit

@available(macOS 13, iOS 16.0, *)
struct HealthKitInterface {
    var healthStore: HKHealthStore = HKHealthStore()
    var typesToRead: [HKObjectType]
    var typesToWrite: [HKSampleType]
    
    
    // Default initialize dictionaries of objects to empty
    init(typesToRead: [HKObjectType] = [], typesToWrite: [HKSampleType] = []) {
        self.typesToRead = typesToRead
        self.typesToWrite = typesToWrite
    }
    
    // Note: HealthKit only enables viewing write permissions not read permissions
    func areWritePermissionsGranted() -> Bool {
        let writeTypesStatus = typesToWrite.map { type -> HKAuthorizationStatus in
            healthStore.authorizationStatus(for: type)
        }
        
        return writeTypesStatus.allSatisfy { $0 == .sharingAuthorized }
    }
    
    
    // Request authorization for initialized data types to read and write
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        let typesToShare = Set(typesToWrite)
        let typesToRead = Set(typesToRead)
        
        healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { success, error in
            DispatchQueue.main.async {
                if success {
                    print("authorization granted")
                    completion(true)
                } else {
                    print("failed to request authorization")
                    completion(false)
                }
            }
        }
    }
    
    
    func queryForTypes(completion: @escaping ([String: [HKSample]]) -> Void) {
        var sampleDictionary = [String: [HKSample]]()
        
        let dispatchGroup = DispatchGroup()
        
        // Query for read types
        for type in typesToRead {
            dispatchGroup.enter()
            
            let sampleType = type as! HKSampleType
            let query = HKSampleQuery(sampleType: sampleType, predicate: nil, limit: 0, sortDescriptors: nil) { (_, results, error) in
                if let samplesResult = results, error == nil {
                    if sampleDictionary[sampleType.identifier] == nil {
                        sampleDictionary[sampleType.identifier] = samplesResult
                    } else {
                        sampleDictionary[sampleType.identifier]?.append(contentsOf: samplesResult)
                    }
                }
                dispatchGroup.leave()
            }
            
            healthStore.execute(query)
        }
        
        // Query for write types
        for type in typesToWrite {
            dispatchGroup.enter()
            
            let query = HKSampleQuery(sampleType: type, predicate: nil, limit: 0, sortDescriptors: nil) { (_, results, error) in
                if let samplesResult = results, error == nil {
                    if sampleDictionary[type.identifier] == nil {
                        sampleDictionary[type.identifier] = samplesResult
                    } else {
                        sampleDictionary[type.identifier]?.append(contentsOf: samplesResult)
                    }
                }
                dispatchGroup.leave()
            }
            
            healthStore.execute(query)
        }
        
        dispatchGroup.notify(queue: .main) {
            completion(sampleDictionary)
        }
    }
    
    
    func transformData(userId: String, samples: [HKSample]) -> Data? {
        var transformedData: [[String: Any]] = []
        
        for sample in samples {
            if let quantitySample = sample as? HKQuantitySample {
                let quantityType = quantitySample.quantityType
                if let defaultUnit = getUnit(quantityType: quantityType) {
                    let count = quantitySample.count
                    let quantity = quantitySample.quantity.doubleValue(for: defaultUnit)
                    let startDate = quantitySample.startDate
                    let endDate = quantitySample.endDate
                    let device = quantitySample.device
                    let metadata = quantitySample.metadata
                    let observation_id = quantitySample.uuid.uuidString
                    
                    let data: [String: Any] = [
                        "user_id": userId,
                        "observation_id": observation_id,
                        "count": String(describing: count),
                        "quantity_type": quantityType.identifier,
                        "quantity": String(describing: quantity),
                        "start_date": String(describing: startDate),
                        "end_date": String(describing: endDate),
                        "device": String(describing: device)
                        //TODO: convert metadata to a string
                    ]
                    
                    transformedData.append(data)
                }
            }
        }
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: transformedData, options: [])
            return jsonData
        } catch {
            print("Error serializing JSON data: \(error)")
            return nil
        }
    }
}
