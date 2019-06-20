//
//  File.swift
//  
//
//  Created by Christian Ampe on 6/19/19.
//

import Foundation

public protocol SteeringRequestValidationProtocol {
    var statusCodes: [Int] { get }
}

/// Represents the status codes to validate through Alamofire.
public enum SteeringRequestValidation: SteeringRequestValidationProtocol {
    
    /// No validation.
    case none
    
    /// Validate success codes.
    case successCodes
    
    /// Validate success codes and redirection codes.
    case successAndRedirectCodes
    
    /// Validate only the given status codes.
    case customCodes([Int])
}

public extension SteeringRequestValidation {

    /// The list of HTTP status codes to validate.
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
