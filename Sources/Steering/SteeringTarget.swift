//
//  Created by Christian Ampe on 6/26/19.
//

public protocol SteeringTarget {
    
    /// The associated request object.
    associatedtype Request: SteeringRequest
    
    /// The request to be executed by the networking service.
    var request: Request { get }
}
