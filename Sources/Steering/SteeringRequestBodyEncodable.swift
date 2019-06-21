//
//  Created by Christian Ampe on 6/19/19.
//

import Foundation

struct SteeringRequestBodyEncodable {
    private let encodable: Encodable
    
    init(_ encodable: Encodable) {
        self.encodable = encodable
    }
}

extension SteeringRequestBodyEncodable: Encodable {
    func encode(to encoder: Encoder) throws {
        try encodable.encode(to: encoder)
    }
}
