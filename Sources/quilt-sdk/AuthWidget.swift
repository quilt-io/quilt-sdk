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
    @State private var showModal = true // Show the modal by default
    
    public init(){}

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
                    healthKitInterface.requestAuthorization { success in
                        if success {
                            isConnectedToHealthKit = true
                        }
                    }
                }
            }
            .padding()
            .foregroundColor(.white)
            .background(isConnectedToHealthKit ? Color.green : Color.blue)
            .cornerRadius(10)

            Spacer()

            Button("Done") {
                showModal = false // Set showModal to false to close the modal
            }
            .font(.headline)
            .padding()
        }
        .padding()
        .sheet(isPresented: $showModal) {
            EmptyView() // An empty view to trigger the sheet presentation
        }
    }
}
