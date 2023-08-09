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
        
    public var body: some View {
        VStack {
            Text("Connect Your Data Sources")
                .font(.headline)
                .padding()
            
            Button(isConnectedToHealthKit ? "Connected" : "Connect to Apple Health") {
                if isConnectedToHealthKit {
                    // Handle disconnection logic
                } else {
                    // TODO: fix this later, predefining to simplify initial implementation
                    let typesToRead = [dataTypes.heartRate.quantityType]
                    let healthKitInterface = HealthKitInterface(typesToRead: typesToRead)
                    healthKitInterface.requestAuthorization()
                }
            }
            .padding()
            .foregroundColor(.white)
            .background(isConnectedToHealthKit ? Color.green : Color.blue)
            .cornerRadius(10)
            
            Spacer()
            
            Button("Done") {
                // Close the modal
            }
            .font(.headline)
            .padding()
        }
        .padding()
    }
}