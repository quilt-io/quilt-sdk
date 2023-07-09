//
//  File.swift
//  
//
//  Created by Jessica Petrochuk on 7/5/23.
//

import Foundation
import HealthKit

// Class that allows for easier interaction with the Quilt API
@available(macOS 13, iOS 16.0, *)
public class QuiltClient {
    private let apiKey: String
    private let api: String

    public init(apiKey: String) {
        self.apiKey = apiKey
        // TODO: specify the api key in the url
        self.api = "https://mwqjkgk1m6.execute-api.us-east-1.amazonaws.com/Prod/"
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
        request.addValue(apiKey, forHTTPHeaderField: "x-api-key")
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
    
    
    private func sendData(jsonData: Data) {
        let session = URLSession.shared
        let apiUrl = URL(string: "https://mwqjkgk1m6.execute-api.us-east-1.amazonaws.com/Prod/users/data?table_name=quilt_heart_rate")!

        var request = URLRequest(url: apiUrl)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        request.addValue(apiKey, forHTTPHeaderField: "x-api-key")

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
        
        // Request authorization for the user data
        healthKitInterface.requestAuthorization()
        
        let samples = await withCheckedContinuation { continuation in
            healthKitInterface.queryForTypes { (sampleDictionary) in
                        continuation.resume(returning: sampleDictionary)
                    }
            }
        print(samples)
        let transformedResult = healthKitInterface.transformData(userId: "123", samples: samples)
        print(transformedResult)

        switch transformedResult {
        case .failure(let error):
            print("Failed to transform data: \(error)")
            return
        case.success(let jsonData):
            sendData(jsonData: jsonData)
        }
        
    }
}
