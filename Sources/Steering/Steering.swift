//
//  Created by Christian Ampe on 5/28/19.
//

import Foundation
import Tyre

public protocol SteeringProtocol {
    
    /// A request method used for requesting any service supported network calls.
    /// - Parameter target: Enum holding possible network requests
    /// - Parameter completion: Result returning either a parsed model or an error.
    /// - Returns: A session data task if a new network call is made. Nil if the cache is utilized.
    @discardableResult
    func request<T: Decodable>(_ type: T, from target: SteeringRequest, completion: @escaping (Result<SteeringResponse<T>, SteeringError>) -> Void) -> URLSessionDataTask?
}

// MARK: - Networking Class
public class Steering {
    
    /// An initialized provider holding reference to the innerworkings of the service layer.
    private let service: Tyre
    
    public init(_ service: Tyre = .init()) {
        self.service = service
    }
}

// MARK: - Public API
extension Steering: SteeringProtocol {
    
    /// A request method used for requesting any service supported network calls.
    /// - Parameter target: Enum holding possible network requests
    /// - Parameter completion: Result returning either a parsed model or an error.
    /// - Returns: A session data task if a new network call is made. Nil if the cache is utilized.
    @discardableResult
    public func request<T: Decodable>(_ type: T,
                                      from target: SteeringRequest,
                                      completion: @escaping (Result<SteeringResponse<T>, SteeringError>) -> Void) -> URLSessionDataTask? {
        
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
                    let item = try Steering.jsonDecoder.decode(T.self, from: response.data)
                    let response = SteeringResponse(item: item)
                    
                    // Successfully parsed the resulting data.
                    completion(.success(response))
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

private extension Steering {
    static let jsonDecoder = JSONDecoder()
}
