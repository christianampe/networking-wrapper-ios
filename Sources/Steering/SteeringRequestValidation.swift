//
//  Created by Christian Ampe on 6/19/19.
//

import Foundation

public protocol SteeringRequestValidation {
    
    /// The status codes to be validated for.
    var statusCodes: [Int] { get }
}
