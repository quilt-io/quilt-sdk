//
//  File.swift
//  
//
//  Created by Jessica Petrochuk on 8/8/23.
//
import SwiftUI
import Foundation

@available(macOS 13, iOS 16.0, *)
public struct AuthWidget: View {
    @State private var isConnectedToHealthKit = false
    @Binding var showWidget: Bool // Pass in a binding to showModal
    
    // TODO: figure out if API keys need to be used here to initialize
    private let apiKey: String
    private let api: String
    private let sourceId: String
    
    // TODO: figure out where the user ID should be passed
    private let userId: String
    

    public init(showWidget: Binding<Bool>, apiKey: String, sourceId: String, userId: String) {
        _showWidget = showWidget
        self.apiKey = apiKey
        // TODO: specify the api key in the url
        self.api = "https://3ykxtwpvi2.execute-api.us-east-1.amazonaws.com/Prod/users"
        self.sourceId = sourceId
        self.userId = userId
    }

    public var body: some View {
        VStack {
            Text("Let's get connected!")
                            .font(.title)
                            .padding(.top, 20)
                        
            Spacer()

            Button(isConnectedToHealthKit ? "Connected" : "Connect to Apple Health") {
                if isConnectedToHealthKit {
                    // Handle disconnection logic
                } else {
                    // TODO: fix this later, predefining to simplify initial implementation
                    let typesToRead = [dataTypes.heartRate.quantityType]
                    let healthKitInterface = HealthKitInterface(typesToRead: typesToRead)
                    healthKitInterface.requestAuthorization { success in
                        if success {
                            isConnectedToHealthKit = true
                            print("Connected to HeslthKit")
                            print("Starting URL session")
                            let session = URLSession.shared
                            
                            let baseURL = URL(string: api)!

                            let userId = URLQueryItem(name: "user_id", value: userId)
                            let sourceId = URLQueryItem(name: "source_id", value: sourceId)
                            
                            let url = baseURL.appending(queryItems: [
                                userId,
                                sourceId
                            ])
                            
    
                            var request = URLRequest(url: url)
                            request.httpMethod = "POST"
                            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                            request.addValue(apiKey, forHTTPHeaderField: "Authorization")
                            
                            let task = session.dataTask(with: request) { (data, response, error) in
                                if let error = error {
                                    print(error)
                                    return
                                }
                                print(response)
                                print(data)
                            }
                            task.resume()
                        }
                    }
                
//                    QuiltClient(apiKey: apiKey)
//                    QuiltClient.getUserData(<#T##self: QuiltClient##QuiltClient#>)
                }
            }
            .padding()
            .foregroundColor(.white)
            .background(isConnectedToHealthKit ? Color.green : Color.blue)
            .cornerRadius(10)

            Spacer()

            Button("Done") {
                showWidget = false // Set showModal to false using the binding
            }
            
            Spacer()
            
            Text("Powered by Quilt")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .padding(.bottom, 20)
        }
        .padding()
    }
}
