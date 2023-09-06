//
//  SwiftUIView.swift
//  
//
//  Created by Jessica Petrochuk on 9/4/23.
//

import SwiftUI
import HealthKit

@available(macOS 13, iOS 16.0, *)
struct DataSourcesButtonsView: View {
    @State private var isConnectedToHealthKit = false
    @State private var isConnectedToFitbit = false
    
    let quiltClient: QuiltClient
    let userId: String
    let dataSources: [String]
    let typesToRead: [HKObjectType]
    
    init(dataSources: [String], quiltClient: QuiltClient, userId: String, typesToRead: [HKObjectType]) {
        self.quiltClient = quiltClient
        self.userId = userId
        self.dataSources = dataSources
        self.typesToRead = typesToRead
    }

    var body: some View {
        VStack(spacing: 20) {
            ForEach(dataSources, id: \.self) { dataSource in
                switch dataSource {
                case "Health Kit":
                    HealthKitButtonView(isConnectedToHealthKit: $isConnectedToHealthKit, quiltClient: quiltClient, userId: userId, typesToRead: typesToRead)
                case "Fitbit":
                    FitbitButtonView(isConnectedToFitbit: $isConnectedToFitbit, quiltClient: quiltClient, userId: userId)
                default:
                    Spacer()
                }
            }
        }
    }
}
