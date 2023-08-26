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
    @Binding var showWidget: Bool
    
    private let quiltClient: QuiltClient
    private let userId: String
    

    public init(showWidget: Binding<Bool>, quiltClient: QuiltClient, userId: String) {
        _showWidget = showWidget
        self.quiltClient = quiltClient
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
                    Task {
                        let typesToRead = [dataTypes.heartRate.quantityType]
                        await quiltClient.getUserData(userId: userId, typesToRead: typesToRead)
                    }
                }
            }
            .padding()
            .foregroundColor(.white)
            .background(isConnectedToHealthKit ? Color.green : Color.blue)
            .cornerRadius(10)

            Spacer()

            Button("Done") {
                showWidget = false
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
