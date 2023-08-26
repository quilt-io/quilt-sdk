//
//  File.swift
//  
//
//  Created by Jessica Petrochuk on 7/5/23.
//

import Foundation
import HealthKit

@available(macOS 13, iOS 16.0, *)
public class QuiltClient {
    private let apiKey: String
    private let api: String
    private let sourceId: String

    public init(apiKey: String, sourceId: String) {
        self.sourceId = sourceId
        self.apiKey = apiKey
        self.api = "https://3ykxtwpvi2.execute-api.us-east-1.amazonaws.com/Prod/users"
    }
    
    
    public func createUser(userId: String) {
        let endpoint = "/users"
        let queryItems = [URLQueryItem(name: "user_id", value: userId)]
        
        var urlComponents = URLComponents(string: api + endpoint)
        urlComponents?.queryItems = queryItems
        
        guard let url = urlComponents?.url else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue(apiKey, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])
                print(error)
                return
            }
            
            if (200...299).contains(httpResponse.statusCode) {
                print("Successfully created user")
            } else {
                let error = NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Request failed with status code: \(httpResponse.statusCode)"])
                print(error)
            }
        }
        
        task.resume()
    }
    
    
    private func sendData(jsonData: Data, tableName: String) {
        let session = URLSession.shared
        let apiUrl = URL(string: "\(api)/data?table_name=heart-rate&source_id=\(sourceId)")!
        print(apiUrl)
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        request.addValue(apiKey, forHTTPHeaderField: "Authorization")

        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error)
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])
                print(error)
                return
            }

            if (200...299).contains(httpResponse.statusCode) {
                print("Data sent successfully!")
            } else {
                let error = NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Request failed with status code: \(httpResponse.statusCode)"])
                print(error)
            }
        }

        task.resume()
    }
    
    
    public func getUserData(userId: String, typesToRead: [HKObjectType]) async {
        let healthKitInterface = HealthKitInterface(typesToRead: typesToRead)
        
        healthKitInterface.requestAuthorization { success in
            if success {
                print("Connected to HealthKit")
            }
        }
        
        let samples: [String: [HKSample]] = await withCheckedContinuation { continuation in
            healthKitInterface.queryForTypes { (sampleDictionary) in
                        continuation.resume(returning: sampleDictionary)
                    }
            }
        
        for (sampleType, sampleArray) in samples {
            if let jsonData = healthKitInterface.transformData(userId: userId, samples: sampleArray) {
//                print("Transformed!")
//                if let jsonString = String(data: jsonData, encoding: .utf8) {
//                        print(jsonString)
//                    } else {
//                        print("Failed to convert JSON data to string")
//                    }
                sendData(jsonData: jsonData, tableName:sampleType)
            } else {
                print("Failed to get JSON data")
            }
        }
    }
}
