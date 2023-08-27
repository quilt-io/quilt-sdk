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
            Image("Apple_Health_Icon")
            Spacer()

            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray, lineWidth: 2)
                    .frame(height: 60)
                
                Button(action: {
                    if isConnectedToHealthKit {
                        // Handle disconnection logic
                    } else {
                        // TODO: fix this later, predefining to simplify initial implementation
                        Task {
                            let typesToRead = [dataTypes.heartRate.quantityType]
                            await quiltClient.getUserData(userId: userId, typesToRead: typesToRead)
                            isConnectedToHealthKit = true
                        }
                    }
                }) {
                    HStack {
                        Image("Apple_Health_Icon")
//                            .resizable()
//                            .aspectRatio(contentMode: .fit)
//                            .frame(width: 30, height: 30)
                        
                        Text(isConnectedToHealthKit ? "Connected" : "Connect to Apple Health")
                            .foregroundColor(.blue)
                            .fontWeight(.bold)
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .padding()
            
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
