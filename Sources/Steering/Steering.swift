//
//  Created by Christian Ampe on 5/28/19.
//

import Foundation
import Tyre

// MARK: - Private Interface
private protocol SteeringInterface {
    
    /// The associated network request targets.
    associatedtype Target: SteeringRequest
    
    /// The associated error passed back when performing a failed task.
    associatedtype Error: Swift.Error
    
    /// A request method used for requesting any service supported network calls.
    ///
    /// - Parameter target: Enum holding possible network requests
    /// - Parameter completion: Result returning either a parsed model or an error.
    /// - Returns: A session data task if a new network call is made.
    @discardableResult
    func request<Response: Decodable>(_ type: Response,
                                      with jsonDecoder: JSONDecoder,
                                      from target: Target,
                                      completion: @escaping (Result<Response, Error>) -> Void) -> URLSessionDataTask
}

// MARK: - Class Declaration
public struct Steering<Target: SteeringRequest> {
    
    /// The service layer responsible for making network requests.
    private let service = Tyre()
}

// MARK: - SteeringInterface Conformation
extension Steering: SteeringInterface {
    @discardableResult
    func request<Response: Decodable>(_ type: Response,
                                      with jsonDecoder: JSONDecoder,
                                      from request: Target,
                                      completion: @escaping (Result<Response, SteeringError>) -> Void) -> URLSessionDataTask {
        
        // Make a request to specified target.
        return service.task(request.urlRequest) { result in
            
            // Switch on the result of the network request.
            switch result {
                
            case .success(let response):
                
                let statusCode = response.response.statusCode
                
                // Validate the response status code from specified target.
                guard request.validation.statusCodes.contains(statusCode) else {
                    
                    // An invalid status code was found.
                    completion(.failure(.validation(statusCode)))
                    return
                }
                
                do {
                    
                    // Attempt to parse the data returned from the network request.
                    let item = try jsonDecoder.decode(Response.self, from: response.data)
                    
                    // Successfully parsed the resulting data.
                    completion(.success(item))
                } catch {
                    
                    // Unable to parse the resulting data.
                    completion(.failure(.parsing(error)))
                }
                
            case .failure(let error):
                switch error {
                case .unresponsive:
                    completion(.failure(.unresponsive))
                case .underlying(let error):
                    completion(.failure(.underlying(error)))
                }
            }
        }
    }
}
