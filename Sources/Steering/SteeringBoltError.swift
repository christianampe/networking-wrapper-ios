//
//  File.swift
//  
//
//  Created by Christian Ampe on 6/26/19.
//

import Foundation

public enum SteeringBoltError: Error {
    
    /// Returned when the server cannot be reached.
    case unresponsive
    
    /// Returned when with the `URLSession` fails.
    case underlying(Error)
}
