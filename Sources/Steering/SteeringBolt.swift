//
//  Created by Christian Ampe on 6/19/19.
//

import Foundation

public protocol SteeringBolt {
    
    /// The error to be returned from an unsuccessful network task.
    associatedtype Error: Swift.Error
    
    /// The response to be returned from a successful network task.
    associatedtype Response: SteeringBoltResponse
    
    /// The core method wrapping a `URLSession` `dataTask`.
    /// - Parameter request: A request object containing all information necessary for making the network request.
    /// - Parameter completion: A  generic result containing either an error or successful response.
    @discardableResult func task(_ request: URLRequest, completion: @escaping (Result<Response, Error>) -> Void) -> URLSessionDataTask
}
