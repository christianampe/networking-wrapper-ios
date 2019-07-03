//
//  Created by Christian Ampe on 6/26/19.
//

import Foundation.NSJSONSerialization

struct SteeringRequestBodyEncodable {
    
    /// The object to be passed as data in the request body.
    private let encodable: Encodable
    
    /// An explicit initializer.
    /// 
    /// - Parameter encodable: The object to be passed as data in the request body.
    init(_ encodable: Encodable) {
        self.encodable = encodable
    }
}

// MARK: - Encodable Conformance
extension SteeringRequestBodyEncodable: Encodable {
    func encode(to encoder: Encoder) throws {
        try encodable.encode(to: encoder)
    }
}
