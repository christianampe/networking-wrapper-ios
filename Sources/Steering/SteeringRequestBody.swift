//
//  Created by Christian Ampe on 6/19/19.
//

import Foundation

// MARK: - Interface
protocol SteeringRequestBodyInterface {
    
    /// The data to be passed in the http body.
    var data: Data? { get }
}

public enum SteeringRequestBody {
    
    /// A request with no additional data.
    case none
    
    /// A requests body set with data.
    case data(Data)
    
    /// A request body set with `Encodable` type
    case jsonEncodable(Encodable, jsonEncoder: JSONEncoder)
}

// MARK: - SteeringRequestBodyInterface Conformation
extension SteeringRequestBody: SteeringRequestBodyInterface {
    var data: Data? {
        switch self {
        case .none:
            return nil
        case .data(let data):
            return data
        case .jsonEncodable(let encodable, let jsonEncoder):
            return try? jsonEncoder.encode(SteeringRequestBodyEncodable(encodable))
        }
    }
}
