//
//  Created by Christian Ampe on 5/28/19.
//

import Foundation

protocol SteeringResponseProtocol {
    
    /// The data returned from the network request.
    var data: Data { get }
    
    /// The url  request sent to server.
    var request: URLRequest { get }
    
    /// The http url response returned from server.
    var response: HTTPURLResponse { get }
}

struct SteeringResponse: SteeringResponseProtocol {
    
    /// Data returned from the network request.
    let data: Data
    
    /// URL request sent to server.
    let request: URLRequest
    
    /// HTTP url response returned from server.
    let response: HTTPURLResponse
    
    /// Explicit initializer.
    /// - Parameter data: The data returned from the network request.
    /// - Parameter request: The url request sent to server.
    /// - Parameter response: The HTTP url response returned from server.
    init(data: Data,
         request: URLRequest,
         response: HTTPURLResponse) {
        
        self.data = data
        self.request = request
        self.response = response
    }
}
