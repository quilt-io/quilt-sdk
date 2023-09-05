//
//  SwiftUIView.swift
//  
//
//  Created by Jessica Petrochuk on 9/4/23.
//

import SwiftUI

@available(macOS 13, iOS 16.0, *)
struct HealthKitButtonView: View {
    @Binding var isConnectedToHealthKit: Bool
    
    let quiltClient: QuiltClient
    let userId: String
    
    init(isConnectedToHealthKit: Binding<Bool>, quiltClient: QuiltClient, userId: String) {
        self._isConnectedToHealthKit = isConnectedToHealthKit
        self.quiltClient = quiltClient
        self.userId = userId
    }
    
    var body: some View {
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
                    Image("HealthKitIcon", bundle: .module)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                        .padding(.leading, 30)
                    
                    Text(isConnectedToHealthKit ? "Connected to Apple Health" : "Connect to Apple Health")
                        .foregroundColor(Color(red: 221/255, green: 221/255, blue: 221/255))
                        .fontWeight(.bold)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(width: 300)
    }
}
