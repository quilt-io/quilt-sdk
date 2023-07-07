//
//  File.swift
//  
//
//  Created by Jessica Petrochuk on 7/5/23.
//

import Foundation

// Class that allows for easier interaction with the Quilt API
public class QuiltClient {
    private let apiKey: String
    private let api: String

    public init(apiKey: String) {
        self.apiKey = apiKey
        // TODO: specify the api key in the url
        self.api = "https://mwqjkgk1m6.execute-api.us-east-1.amazonaws.com/Prod/"
    }
    
    func createUser(userId: String) {
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
    // create user function - placed before the widget after app authentication, once a user is authenti
    //
}
