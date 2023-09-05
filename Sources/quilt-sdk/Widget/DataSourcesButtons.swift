//
//  SwiftUIView.swift
//  
//
//  Created by Jessica Petrochuk on 9/4/23.
//

import SwiftUI

@available(macOS 13, iOS 16.0, *)
struct DataSourcesButtonsView: View {
    @State private var isConnectedToHealthKit = false
    @State private var isConnectedToFitbit = false
    
    let quiltClient: QuiltClient
    let userId: String
    let dataSources: [String]
    
    init(dataSources: [String], quiltClient: QuiltClient, userId: String) {
        self.quiltClient = quiltClient
        self.userId = userId
        self.dataSources = dataSources
    }

    var body: some View {
        VStack(spacing: 20) {
            ForEach(dataSources, id: \.self) { dataSource in
                switch dataSource {
                case "Health Kit":
                    HealthKitButtonView(isConnectedToHealthKit: $isConnectedToHealthKit, quiltClient: quiltClient, userId: userId)
                case "Fitbit":
                    FitbitButtonView(isConnectedToFitbit: $isConnectedToFitbit, quiltClient: quiltClient, userId: userId)
                default:
                    Spacer()
                }
            }
        }
    }
}
