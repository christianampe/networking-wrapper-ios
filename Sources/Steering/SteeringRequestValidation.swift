//
//  Created by Christian Ampe on 6/19/19.
//

import Foundation

// MARK: - Interface
protocol SteeringRequestValidationInterface {
    
    /// The status codes to be validated for.
    var statusCodes: [Int] { get }
}

// MARK: - Class Declaration
public enum SteeringRequestValidation {
    
    /// No validation.
    case none
    
    /// Validate success codes.
    case successCodes
    
    /// Validate success codes and redirection codes.
    case successAndRedirectCodes
    
    /// Validate only the given status codes.
    case customCodes([Int])
}

// MARK: - SteeringRequestValidation Conformance
extension SteeringRequestValidation: SteeringRequestValidationInterface {
    var statusCodes: [Int] {
        switch self {
        case .successCodes:
            return Array(200..<300)
        case .successAndRedirectCodes:
            return Array(200..<400)
        case .customCodes(let codes):
            return codes
        case .none:
            return []
        }
    }
}
