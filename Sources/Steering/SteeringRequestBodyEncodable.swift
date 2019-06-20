//
//  Created by Christian Ampe on 6/19/19.
//

import Foundation

struct SteeringRequestBodyEncodable: Encodable {
    private let encodable: Encodable
    
    init(_ encodable: Encodable) {
        self.encodable = encodable
    }
}

extension SteeringRequestBodyEncodable {
    func encode(to encoder: Encoder) throws {
        try encodable.encode(to: encoder)
    }
}
