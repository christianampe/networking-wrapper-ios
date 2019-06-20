//
//  Created by Christian Ampe on 5/28/19.
//

import Foundation

public protocol SteeringProtocol {
    
    /// Request method used for requesting any service supported network calls.
    /// - Parameter target: Enum holding possible network requests
    /// - Parameter completion: Result returning either a parsed model or an error.
    /// - Returns: A session data task if a new network call is made. Nil if the cache is utilized.
    @discardableResult
    func request(_ target: SteeringRequest,
                 completion: @escaping (Result<SteeringResponse, SteeringError>) -> Void) -> URLSessionDataTask?
}

// MARK: - Networking Class
public class Steering : SteeringProtocol {
    
    /// Initialized provider holding reference to the innerworkings of the service layer.
    private let service: SteeringBoltProtocol
    
    public init(service: SteeringBoltProtocol) {
        self.service = service
    }
}

// MARK: - Internal API
public extension Steering {
    
    /// Request method used for requesting any service supported network calls.
    /// - Parameter target: Enum holding possible network requests
    /// - Parameter completion: Result returning either a parsed model or an error.
    /// - Returns: A session data task if a new network call is made. Nil if the cache is utilized.
    @discardableResult
    func request(_ target: SteeringRequest,
                 completion: @escaping (Result<SteeringResponse, SteeringError>) -> Void) -> URLSessionDataTask? {
        
        // make request to specified target
        return service.task(target.urlRequest) { result in
            
            // switch on result of network request
            switch result {
                
            case .success(let response):
                
                let providerResponse = SteeringResponse(data: response.data,
                                                        request: response.request,
                                                        response: response.response)
                
                
                // successful result
                completion(.success(providerResponse))
                
            case .failure(let error):
                
                // something went wrong with the network request
                completion(.failure(.service(error)))
            }
        }
    }
}
