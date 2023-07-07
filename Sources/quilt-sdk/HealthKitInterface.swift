//
//  File.swift
//  
//
//  Created by Jessica Petrochuk on 7/6/23.
//

import Foundation
import HealthKit

struct HealthKitInterface {
    var healthStore: HKHealthStore = HKHealthStore()
    var typesToRead: [HKObjectType: HKUnit]
    var typesToWrite: [HKSampleType: HKUnit]
    
    
    // Default initialize dictionaries of objects to empty
    init(typesToRead: [HKObjectType: HKUnit] = [:], typesToWrite: [HKSampleType: HKUnit] = [:]) {
        self.typesToRead = typesToRead
        self.typesToWrite = typesToWrite
    }
    
    
    // Request authorization for initialized data types to read and write
    func requestAuthorization() {
        let typesToShare = Set(typesToWrite.keys)
        let typesToRead = Set(typesToRead.keys)
        
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
        for (type, _) in typesToRead {
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
        for (type, _) in typesToWrite {
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
    
    
    func transformData(userId: String, samples: [String: [HKSample]]) -> Data {
        var transformedData: [[String: Any]] = []
        
        for (sampleType, sampleArray) in samples {
            for sample in sampleArray {
                if let quantitySample = sample as? HKQuantitySample {
                    let quantityType = quantitySample.quantityType
                    if let defaultUnit = typesToRead[quantityType] {
                        let quantity = quantitySample.quantity.doubleValue(for: defaultUnit)
                        let startDate = quantitySample.startDate
                        let endDate = quantitySample.endDate
                        
                        let data: [String: Any] = [
                            "userId": userId,
                            "quantityType": quantityType.identifier, //TODO: make sure this doesn't need to be converted to a string
                            "quantity": String(describing: quantity),
                            "startDate": String(describing: startDate),
                            "endDate": String(describing: endDate)
                        ]
                        
                        transformedData.append(data)
                    }
                }
            }
        }
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: transformedData, options: [])
            return jsonData
        } catch {
            print(error)
            return // TODO : fix this
        }
    }
    
    
    func sendData(completion: @escaping (Result<Void, Error>) -> Void) async {
        let samples = await withCheckedContinuation { continuation in
                    queryForTypes { (sampleDictionary) in
                        continuation.resume(returning: sampleDictionary)
                    }
            }
        let jsonData = transformData(userId: "Test123456", samples: samples)

        let session = URLSession.shared
        let apiUrl = URL(string: "https://mwqjkgk1m6.execute-api.us-east-1.amazonaws.com/Prod/users/data?table_name=quilt_heart_rate")!

        var request = URLRequest(url: apiUrl)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData


        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])
                completion(.failure(error))
                return
            }

            if (200...299).contains(httpResponse.statusCode) {
                completion(.success(()))
            } else {
                let error = NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Request failed with status code: \(httpResponse.statusCode)"])
                completion(.failure(error))
            }
        }

        task.resume()
    }
}
