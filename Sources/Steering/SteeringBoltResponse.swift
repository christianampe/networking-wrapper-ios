//
//  Created by Christian Ampe on 6/21/19.
//

import Foundation

private protocol SteeringBoltResponseInterface {
    
    /// The data returned from the network request.
    var data: Data { get }
    
    /// The url  request sent to server.
    var request: URLRequest { get }
    
    /// The http url response returned from server.
    var response: HTTPURLResponse { get }
}

public struct SteeringBoltResponse: SteeringBoltResponseInterface {
    let data: Data
    let request: URLRequest
    let response: HTTPURLResponse
}
