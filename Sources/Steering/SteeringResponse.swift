//
//  Created by Christian Ampe on 5/28/19.
//

import Foundation

public protocol SteeringResponseProtocol {
    associatedtype T: Decodable
    
    /// The fully-parsed item returned from the server.
    var item: T { get }
}

public struct SteeringResponse<T: Decodable>: SteeringResponseProtocol {
    
    /// The fully-parsed item returned from the server.
    public let item: T
}
