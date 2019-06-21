//
//  Created by Christian Ampe on 5/28/19.
//

import Foundation

public protocol Steering {
    associatedtype Error: Swift.Error
    associatedtype Bolt: SteeringBolt
    
    var service: Bolt { get set }
    
    /// A request method used for requesting any service supported network calls.
    /// - Parameter type: The generic `Decodable` type to be parsed by the `jsonDecoder`.
    /// - Parameter jsonDecoder: The `JSONDecoder` used to parse the generic `Decodable` type.
    /// - Parameter target: Enum holding possible network requests
    /// - Parameter completion: Result returning either a parsed model or an error.
    /// - Returns: A session data task if a new network call is made.
    @discardableResult func request<T: Decodable>(_ type: T, with jsonDecoder: JSONDecoder, from target: SteeringRequest, completion: @escaping (Result<T, Error>) -> Void) -> URLSessionDataTask?
}

extension Steering {
    
    /// A request method used for requesting any service supported network calls.
    /// - Parameter type: The generic `Decodable` type to be parsed by the `jsonDecoder`.
    /// - Parameter jsonDecoder: The `JSONDecoder` used to parse the generic `Decodable` type.
    /// - Parameter target: Enum holding possible network requests
    /// - Parameter completion: Result returning either a parsed model or an error.
    /// - Returns: A session data task if a new network call is made.
    @discardableResult
    public func request<T: Decodable>(_ type: T,
                                      with jsonDecoder: JSONDecoder,
                                      from target: SteeringRequest,
                                      completion: @escaping (Result<T, SteeringError>) -> Void) -> URLSessionDataTask? {
        
        // Make a request to specified target.
        return service.task(target.urlRequest) { result in
            
            // Switch on the result of the network request.
            switch result {
                
            case .success(let response):
                
                let statusCode = response.response.statusCode
                
                // Validate the response status code from specified target.
                guard target.validation.statusCodes.contains(statusCode) else {
                    
                    // An invalid status code was found.
                    completion(.failure(.validation(statusCode)))
                    return
                }
                
                do {
                    
                    // Attempt to parse the data returned from the network request.
                    let item = try jsonDecoder.decode(T.self, from: response.data)
                    
                    // Successfully parsed the resulting data.
                    completion(.success(item))
                } catch {
                    
                    // Unable to parse the resulting data.
                    completion(.failure(.parsing(error)))
                }
                
            case .failure(let error):
                
                // something went wrong with the network request
                completion(.failure(.service(error)))
            }
        }
    }
}
