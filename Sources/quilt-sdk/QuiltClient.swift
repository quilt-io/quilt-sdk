//
//  File.swift
//  
//
//  Created by Jessica Petrochuk on 7/5/23.
//

import Foundation

// Class that allows for easier interaction with the Quilt API
@available(macOS 13, *)
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
        let url = URL(string: self.api + endpoint)!
        let session = URLSession.shared
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
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
        
    }
    
    // 
    public func getUserData(userId: String, typesToRead: [String]) async {
        let healthKitInterface = HealthKitInterface()
        
        // Request authorization for the user data
        healthKitInterface.requestAuthorization()
        
        let samples = await withCheckedContinuation { continuation in
            healthKitInterface.queryForTypes { (sampleDictionary) in
                        continuation.resume(returning: sampleDictionary)
                    }
        }
        
        let jsonData = healthKitInterface.transformData(userId: "Test123456", samples: samples)
        
        // TODO: create logic around different tables ss
        
        let session = URLSession.shared
        let apiUrl = URL(string: "https://mwqjkgk1m6.execute-api.us-east-1.amazonaws.com/Prod/users/data?table_name=quilt_heart_rate")!
        var request = URLRequest(url: apiUrl)
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
    }
    // create user function - placed before the widget after app authentication, once a user is authenti
    //
}
