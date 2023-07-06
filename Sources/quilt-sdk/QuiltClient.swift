//
//  File.swift
//  
//
//  Created by Jessica Petrochuk on 7/5/23.
//

import Foundation

class QuiltClient {
    private let apiKey: String

    init(apiKey: String) {
        self.apiKey = apiKey
        print("This worked")
    }
    
    public func helloWorld() {
        print("Hello Jessica")
    }
}
