//
//  SwiftUIView.swift
//  
//
//  Created by Jessica Petrochuk on 8/27/23.
//

import SwiftUI
import UIKit

@available(iOS 16.0, *)
struct SwiftUIView: View {
    @State private var showWidget = false // Declare the state here
    let quiltClient = QuiltClient(apiKey: "XcD8OjkR2V7ZaWiCdzOY77bpxL34afUN9qyIClTA", sourceId: "test_source")
    
    var body: some View {
        Button("Open Modal") {
            showWidget = true
        }
        .sheet(isPresented: $showWidget) {
            AuthWidget(
                showWidget: $showWidget,
                quiltClient: quiltClient,
                userId: "1111",
                dataSources: ["Health Kit"]
            )
        }
    }
}

@available(iOS 16.0, *)
struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}
