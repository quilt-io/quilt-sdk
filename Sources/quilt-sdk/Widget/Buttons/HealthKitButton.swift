//
//  SwiftUIView.swift
//  
//
//  Created by Jessica Petrochuk on 9/4/23.
//

import SwiftUI
import HealthKit

@available(macOS 13, iOS 16.0, *)
struct HealthKitButtonView: View {
    @Binding var isConnectedToHealthKit: Bool
    
    let quiltClient: QuiltClient
    let userId: String
    let typesToRead: [HKObjectType]
    
    init(isConnectedToHealthKit: Binding<Bool>, quiltClient: QuiltClient, userId: String, typesToRead: [HKObjectType]) {
        self._isConnectedToHealthKit = isConnectedToHealthKit
        self.quiltClient = quiltClient
        self.userId = userId
        self.typesToRead = typesToRead
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
                    Task {
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
        .frame(width: 330)
    }
}
