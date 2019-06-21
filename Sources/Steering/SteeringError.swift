//
//  Created by Christian Ampe on 5/28/19.
//

import Foundation

public enum SteeringError: Error {
    
    /// Returned when with the associated networking service error.
    case service(Error)
    
    /// Returned when there is an error with parsing the input data.
    case parsing(Error)
    
    /// Returned when there is an invalid error code response from the server.
    case validation(Int)
}
