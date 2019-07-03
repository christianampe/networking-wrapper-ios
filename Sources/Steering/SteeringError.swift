//
//  Created by Christian Ampe on 5/28/19.
//

public enum SteeringError: Error {
    
    /// Returned when the server cannot be reached.
    case unresponsive
    
    /// Returned when with the `URLSession` fails.
    case underlying(Error)
    
    /// Returned when there is an error with parsing the input data.
    case parsing(Error)
    
    /// Returned when there is an invalid error code response from the server.
    case validation(Int)
}
