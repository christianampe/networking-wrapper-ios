//
//  Created by Christian Ampe on 5/28/19.
//

import Foundation

public enum SteeringError: Error {
    
    /// Returned when with the associated networking service error.
    case service(Error)
    
    case parsing(Error)
    
    case validation(Int)
}
