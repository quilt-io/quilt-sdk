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
        ZStack{
//            Color(red: 230 / 255, green: 230 / 255, blue: 255 / 255)
//                .ignoresSafeArea()
            Color(red: 34 / 255, green: 34 / 255, blue: 34 / 255)
                .ignoresSafeArea()
            VStack {
                Text("Let's get connected!")
                    .foregroundColor(Color(red: 221/255, green: 221/255, blue: 221/255))
                    .font(.title)
                    .padding(.top, 20)
                Spacer()

                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .frame(height: 60)
                        .foregroundColor(Color(red: 42 / 255, green: 42 / 255, blue: 44 / 255))
                    
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
                        HStack(spacing: 20) {
                            Image("Icon", bundle: .module)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 30, height: 30)
 
                            Text(isConnectedToHealthKit ? "Connected" : "Connect to Apple Health")
                                .foregroundColor(Color(red: 221/255, green: 221/255, blue: 221/255))
                                .fontWeight(.bold)
                            
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding()
                
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .frame(height: 60)
                        .foregroundColor(Color(red: 42 / 255, green: 42 / 255, blue: 44 / 255))
                    
                    Button(action: {
                        if isConnectedToHealthKit {
                            // Handle disconnection logic
                        } else {
                            Task {
                                let typesToRead = [dataTypes.heartRate.quantityType]
                                await quiltClient.getUserData(userId: userId, typesToRead: typesToRead)
                                isConnectedToHealthKit = true
                            }
                        }
                    }) {
                        HStack(spacing: 20) {
                            Image("Icon", bundle: .module)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 30, height: 30)
 
                            Text(isConnectedToHealthKit ? "Connected" : "Connect to Apple Health")
                                .foregroundColor(Color(red: 221/255, green: 221/255, blue: 221/255))
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
}
