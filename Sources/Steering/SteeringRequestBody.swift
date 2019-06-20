//
//  Created by Christian Ampe on 6/19/19.
//

import Foundation

protocol SteeringRequestBodyProtocol {
    
    /// The data to be passed in the http body.
    var data: Data? { get }
    
    /// The value of the content-type header.
    var contentType: String? { get }
}

public enum SteeringRequestBody: SteeringRequestBodyProtocol {
    
    /// A request with no additional data.
    case none
    
    /// A requests body set with data.
    case data(Data)
    
    /// A request body set with `Encodable` type
    case jsonEncodable(Encodable)
}

extension SteeringRequestBody {
    var data: Data? {
        switch self {
        case .none:
            return nil
        case .data(let data):
            return data
        case .jsonEncodable(let encodable):
            return try? SteeringRequestBody.jsonEncoder.encode(AnyEncodable(encodable))
        }
    }
    
    var contentType: String? {
        switch self {
        case .none:
            return nil
        case .data:
            return "application/json"
        case .jsonEncodable:
            return "application/json"
        }
    }
}

private extension SteeringRequestBody {
    static let jsonEncoder = JSONEncoder()
}
