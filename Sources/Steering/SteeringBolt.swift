//
//  Created by Christian Ampe on 6/19/19.
//

import Foundation
import Tyre

private protocol SteeringBoltInterface {
    
    /// The error to be returned from an unsuccessful network task.
    associatedtype Error: Swift.Error
    
    /// The core method wrapping a `URLSession` `dataTask`.
    ///
    /// - Parameter request: A request object containing all information necessary for making the network request.
    /// - Parameter completion: A  generic result containing either an error or successful response.
    @discardableResult
    func task(_ request: URLRequest,
              completion: @escaping (Result<SteeringBoltResponse, Error>) -> Void) -> URLSessionDataTask
}

public class SteeringBolt {
    
    /// The  underlying service which makes the network request.
    private let tyre = Tyre<SteeringBoltError>()
}

extension SteeringBolt {
    @discardableResult
    public func task(_ request: URLRequest,
                     completion: @escaping (Result<SteeringBoltResponse, SteeringBoltError>) -> Void) -> URLSessionDataTask {
        
        return tyre.task(request) { result in
            switch result {
            case .success(let response):
                let hand = SteeringBoltResponse(data: response.data,
                                                request: response.request,
                                                response: response.response)
                
                completion(.success(hand))
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
