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
    @Binding var showModal: Bool // Pass in a binding to showModal

    public init(showModal: Binding<Bool>) {
        _showModal = showModal
    }

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
                showModal = false // Set showModal to false using the binding
            }
            .font(.headline)
            .padding()
        }
        .padding()
    }
}
