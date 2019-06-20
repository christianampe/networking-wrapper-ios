//
//  Created by Christian Ampe on 6/19/19.
//

import Foundation

public protocol SteeringBoltProtocol {
    
    /// The core method wrapping a `URLSession` `dataTask`.
    /// - Parameter request: A request object containing all information necessary for making the network request.
    /// - Parameter completion: A  generic result containing either an error or successful response.
    @discardableResult func task(_ request: URLRequest, completion: @escaping (Result<SteeringBoltResponseProtocol, Error>) -> Void) -> URLSessionDataTask
}

public protocol SteeringBoltResponseProtocol {
    
    /// The data returned from the network request.
    var data: Data { get }
    
    /// The url  request sent to server.
    var request: URLRequest { get }
    
    /// The http url response returned from server.
    var response: HTTPURLResponse { get }
}
