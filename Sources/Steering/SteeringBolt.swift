//
//  Created by Christian Ampe on 6/19/19.
//

import Foundation

public protocol SteeringBoltProtocol {
    
    /// The core method wrapping a `URLSession` `dataTask`.
    /// - Parameter request: A request object containing all information necessary for making the network request.
    /// - Parameter completion: A  generic result containing either an error or successful response.
    @discardableResult func task(_ request: URLRequest, completion: @escaping (Result<SteeringResponseProtocol, Error>) -> Void) -> URLSessionDataTask
}
