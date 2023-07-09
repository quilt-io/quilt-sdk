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
    
    
    // Request authorization for initialized data types to read and write
    func requestAuthorization() {
        let typesToShare = Set(typesToWrite)
        let typesToRead = Set(typesToRead)
        
        healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { success, error in
            DispatchQueue.main.async {
                if success {
                    // Authorization granted
                    // Query for types here?
                } else {
                    // Handle authorization failure
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
    
    
    func transformData(userId: String, samples: [String: [HKSample]]) -> Data? {
        var transformedData: [[String: Any]] = []
        
        for (sampleType, sampleArray) in samples {
            for sample in sampleArray {
                if let quantitySample = sample as? HKQuantitySample {
                    let quantityType = quantitySample.quantityType
                    if let defaultUnit = getUnit(quantityType: quantityType) {
                        let quantity = quantitySample.quantity.doubleValue(for: defaultUnit)
                        let startDate = quantitySample.startDate
                        let endDate = quantitySample.endDate
                        
                        let data: [String: Any] = [
                            "user_id": userId,
                            "quantity_type": quantityType.identifier, //TODO: make sure this doesn't need to be converted to a string
                            "step_count": String(describing: quantity),
                            "start_date": String(describing: startDate),
                            "end_date": String(describing: endDate)
                        ]
                        
                        transformedData.append(data)
                    }
                }
            }
        }
        print("Transforming!")
        print(transformedData)
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: transformedData, options: [])
            return jsonData
        } catch {
            print("Error serializing JSON data: \(error)")
            return nil
        }
    }
}
