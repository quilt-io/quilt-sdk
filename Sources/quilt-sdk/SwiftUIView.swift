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
    var body: some View {
        VStack{
            Text("Hello")
            Image("Icon", bundle: .module)
//            if let path = Bundle.module.path(forResource: "Icon", ofType: "png"),
//                let image = UIImage(contentsOfFile: path) {
//                self.init("Icon")
//            }
//            self.init(nsImage: image)
            Text("Bye")
        }
    }
}

@available(iOS 16.0, *)
struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}
