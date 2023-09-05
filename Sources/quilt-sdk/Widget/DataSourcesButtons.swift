//
//  SwiftUIView.swift
//  
//
//  Created by Jessica Petrochuk on 9/4/23.
//

import SwiftUI

@available(macOS 13, iOS 16.0, *)
struct DataSourcesButtonsView: View {
    @Binding var isConnectedToHealthKit: Bool
    
    let quiltClient: QuiltClient
    let userId: String
    let dataSources: [String]
    
    init(dataSources: [String], isConnectedToHealthKit: Binding<Bool>, quiltClient: QuiltClient, userId: String) {
        self._isConnectedToHealthKit = isConnectedToHealthKit // Initialize isConnectedToHealthKit as a Binding
        self.quiltClient = quiltClient
        self.userId = userId
        self.dataSources = dataSources
    }

    var body: some View {
        VStack(spacing: 20) {
            ForEach(dataSources, id: \.self) { dataSource in
                switch dataSource {
                    case "Health Kit":
                        HealthKitButtonView(isConnectedToHealthKit: _isConnectedToHealthKit, quiltClient: quiltClient, userId: userId)
                default:
                    Spacer()
                }
            }
        }
    }
}
