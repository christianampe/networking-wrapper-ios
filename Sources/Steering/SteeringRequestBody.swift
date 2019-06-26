//
//  Created by Christian Ampe on 6/19/19.
//

import Foundation

public protocol SteeringRequestBody {
    
    /// The data to be passed in the http body.
    var data: Data? { get }
}
