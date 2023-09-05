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
    @Binding var showWidget: Bool
    
    private let quiltClient: QuiltClient
    private let userId: String
    private let dataSources: [String]

    public init(showWidget: Binding<Bool>, quiltClient: QuiltClient, userId: String, dataSources: [String]) {
        _showWidget = showWidget
        self.quiltClient = quiltClient
        self.userId = userId
        self.dataSources = dataSources
    }

    public var body: some View {
        ZStack{
            Color(red: 34 / 255, green: 34 / 255, blue: 34 / 255)
                .ignoresSafeArea()
            VStack {
                Text("Let's get connected!")
                    .foregroundColor(Color(red: 221/255, green: 221/255, blue: 221/255))
                    .font(.title)
                    .padding(.top, 20)
                Spacer()
                
                DataSourcesButtonsView(dataSources: dataSources, quiltClient: quiltClient, userId: userId)
                
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
