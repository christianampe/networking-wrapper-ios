//
//  Created by Christian Ampe on 5/28/19.
//

import Foundation

// MARK: - Private Interface
private protocol SteeringInterface {
    
    /// The associated network request targets.
    associatedtype Target: SteeringTarget
    
    /// The associated error passed back when performing a failed task.
    associatedtype Error: Swift.Error
    
    /// The associated structure responsible for making network requests.
    associatedtype Bolt: SteeringBolt
    
    /// A request method used for requesting any service supported network calls.
    ///
    /// - Parameter target: Enum holding possible network requests
    /// - Parameter completion: Result returning either a parsed model or an error.
    /// - Returns: A session data task if a new network call is made.
    @discardableResult
    func request(_ target: Target,
                 completion: @escaping (Result<Target.Request.Response, Error>) -> Void) -> URLSessionDataTask?
}

// MARK: - Class Declaration
public class Steering<Target: SteeringTarget, Bolt: SteeringBolt> {
    
    /// The service layer responsible for making network requests.
    private let service: Bolt
    
    /// The default initializer.
    /// - Parameter service: The service wrapping up a network request method.
    public init(_ service: Bolt) {
        self.service = service
    }
}

// MARK: - SteeringInterface Conformation
extension Steering: SteeringInterface {
    @discardableResult
    func request(_ target: Target,
                 completion: @escaping (Result<Target.Request.Response, SteeringError>) -> Void) -> URLSessionDataTask? {
        
        // Make a request to specified target.
        return service.task(target.request.urlRequest) { result in
            
            // Switch on the result of the network request.
            switch result {
                
            case .success(let response):
                
                let statusCode = response.response.statusCode
                
                // Validate the response status code from specified target.
                guard target.request.validation.statusCodes.contains(statusCode) else {
                    
                    // An invalid status code was found.
                    completion(.failure(.validation(statusCode)))
                    return
                }
                
                do {
                    
                    // Attempt to parse the data returned from the network request.
                    let item = try target.request.jsonDecoder.decode(Target.Request.Response.self, from: response.data)
                    
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
