//
//  Created by Christian Ampe on 5/28/19.
//

import Foundation

public protocol SteeringResponseProtocol {
    
    /// The associated item type.
    associatedtype T: Decodable
    
    /// The explicit initializer.
    /// - Parameter item: The item to be set.
    init(_ item: T)
    
    /// The fully-parsed item returned from the server.
    var item: T { get }
}

public struct SteeringResponse<T: Decodable>: SteeringResponseProtocol {
    
    /// The explicit initializer.
    /// - Parameter item: The item to be set.
    public init(_ item: T) {
        self.item = item
    }
    
    /// The fully-parsed item returned from the server.
    public let item: T
}
