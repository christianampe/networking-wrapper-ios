//
//  Created by Christian Ampe on 5/28/19.
//

import Foundation

// MARK: - Network Request
public protocol SteeringRequest {
    
    /// The associated request method type to be used.
    associatedtype Method: SteeringRequestMethod
    
    /// The associated request body to be used.
    associatedtype Body: SteeringRequestBody
    
    /// The associated request validation to be used.
    associatedtype Validation: SteeringRequestValidation
    
    /// The target's base url.
    var baseURL: URL { get }
    
    /// The http method used in the request.
    var method: Method { get }
    
    /// The path to be appended to base url to form the full url.
    var path: String { get }
    
    /// The parameters to be appended to the full formed url.
    var parameters: [String: String]? { get }
    
    /// The headers to be used in the request.
    var headers: [String: String]? { get }
    
    /// The body to be used in the request.
    var body: SteeringRequestBody { get }
    
    /// The validation to be applied to the status code.
    var validation: SteeringRequestValidation { get }
}

// MARK: - Constructor
public extension SteeringRequest {
    
    /// URL request constructed from the object.
    var urlRequest: URLRequest {
        
        // construct url request from base url
        var urlRequest = URLRequest(url: baseURL)
        
        // add http method type
        addMethod(method, to: &urlRequest)
        
        // add path to url request
        addPath(path, to: &urlRequest)
        
        // add url components
        addQueryParameters(parameters, to: &urlRequest)
        
        // add headers to url request
        addHeaders(headers, to: &urlRequest)
        
        // add http body
        addRequestBody(body, to: &urlRequest)
        
        // return construct request
        return urlRequest
    }
}

// MARK: - Constructor Helpers
private extension SteeringRequest {
    
    /// Adds the http method type to the request.
    /// - Parameter method: HTTP method to be executed.
    /// - Parameter request: Inout url request being constructed.
    func addMethod(_ method: SteeringRequestMethod,
                   to request: inout URLRequest) {
        
        request.httpMethod = method.name
    }
    
    /// Appends the given path to the request url.
    /// - Parameter path: URL endpoint path to be added to the base url.
    /// - Parameter request: Inout url request being constructed.
    func addPath(_ path: String,
                 to request: inout URLRequest) {
        
        request.url?.appendPathComponent(path)
    }
    
    /// Encodes and appends the given request parameters to the request url.
    /// - Parameter parameters: Parameters to be added to the url query.
    /// - Parameter request: Inout url request being constructed.
    func addQueryParameters(_ parameters: [String: String]?,
                            to request: inout URLRequest) {
        
        guard let parameters = parameters, let requestURL = request.url else {
            return
        }
        
        let items = parameters.map { URLQueryItem(name: $0, value: $1) }
        
        var urlComponents = URLComponents(url: requestURL, resolvingAgainstBaseURL: false)
        
        urlComponents?.queryItems = items
        
        request.url = urlComponents?.url
    }
    
    /// Adds given headers to the request.
    /// - Parameter headers: Headers to be added to the http header field.
    /// - Parameter request: Inout url request being constructed.
    func addHeaders(_ headers: [String: String]?,
                    to request: inout URLRequest) {
        
        guard let headers = headers else {
            return
        }
        
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
    
    /// Adds given body data to the request.
    /// - Parameter body: request body to be added.
    /// - Parameter request: Inout url request being constructed.
    func addRequestBody(_ body: SteeringRequestBody?,
                        to request: inout URLRequest) {
        
        guard let body = body else {
            return
        }
        
        if let contentType = body.contentType {
            request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        }

        if let data = body.data {
            request.httpBody = data
        }
    }
}
