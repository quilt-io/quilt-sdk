//
//  SwiftUIView.swift
//  
//
//  Created by Jessica Petrochuk on 8/27/23.
//

import SwiftUI

@available(macOS 13, iOS 16.0, *)
struct SwiftUIView: View {
    var body: some View {
        VStack{
            Text("Hello")
            Image("Icon")
            Text("Bye")
        }
    }
}

@available(macOS 13, iOS 16.0, *)
struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}
