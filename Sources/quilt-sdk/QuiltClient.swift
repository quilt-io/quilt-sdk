//
//  File.swift
//  
//
//  Created by Jessica Petrochuk on 7/5/23.
//

import Foundation

public class QuiltClient {
    private let apiKey: String

    public init(apiKey: String) {
        self.apiKey = apiKey
        print("This worked")
    }
    
    public func helloWorld() {
        print("Hello Jessica")
    }
}
