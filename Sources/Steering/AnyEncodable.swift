//
//  File.swift
//  
//
//  Created by Christian Ampe on 6/19/19.
//

import Foundation

struct AnyEncodable: Encodable {
    private let encodable: Encodable
    
    public init(_ encodable: Encodable) {
        self.encodable = encodable
    }
}

extension AnyEncodable {
    func encode(to encoder: Encoder) throws {
        try encodable.encode(to: encoder)
    }
}
