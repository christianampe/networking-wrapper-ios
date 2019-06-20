//
//  Created by Christian Ampe on 5/28/19.
//

import Foundation

public protocol SteeringResponseProtocol {
    
    /// The data returned from the network request.
    var data: Data { get }
    
    /// The url  request sent to server.
    var request: URLRequest { get }
    
    /// The http url response returned from server.
    var response: HTTPURLResponse { get }
}

public struct SteeringResponse: SteeringResponseProtocol {
    
    /// Data returned from the network request.
    public let data: Data
    
    /// URL request sent to server.
    public let request: URLRequest
    
    /// HTTP url response returned from server.
    public let response: HTTPURLResponse
    
    /// Explicit initializer.
    /// - Parameter data: The data returned from the network request.
    /// - Parameter request: The url request sent to server.
    /// - Parameter response: The HTTP url response returned from server.
    public init(data: Data,
                request: URLRequest,
                response: HTTPURLResponse) {
        
        self.data = data
        self.request = request
        self.response = response
    }
}
