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

public enum SteeringRequestBody {
    
    /// A request with no additional data.
    case requestPlain
    
    /// A requests body set with data.
    case requestData(Data)
    
    /// A request body set with `Encodable` type
    case requestJSONEncodable(Encodable)
}

extension SteeringRequestBody: SteeringRequestBodyProtocol {
    var data: Data? {
        switch self {
        case .requestPlain:
            return nil
        case .requestData(let data):
            return data
        case .requestJSONEncodable(let encodable):
            return try? SteeringRequestBody.jsonEncoder.encode(AnyEncodable(encodable))
        }
    }
    
    var contentType: String? {
        switch self {
        case .requestPlain:
            return nil
        case .requestData:
            return "application/json"
        case .requestJSONEncodable:
            return "application/json"
        }
    }
}

private extension SteeringRequestBody {
    static let jsonEncoder = JSONEncoder()
}
