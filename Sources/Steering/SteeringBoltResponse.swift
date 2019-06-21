//
//  Created by Christian Ampe on 6/21/19.
//

import Foundation

public protocol SteeringBoltResponse {
    
    /// The data returned from the network request.
    var data: Data { get }
    
    /// The url  request sent to server.
    var request: URLRequest { get }
    
    /// The http url response returned from server.
    var response: HTTPURLResponse { get }
}
