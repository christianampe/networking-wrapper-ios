//
//  Created by Christian Ampe on 5/28/19.
//

import Foundation

// MARK: - Interface
public protocol SteeringRequest {
    
    /// The explicit initializer.
    ///
    /// - Parameter input: The object containing required fields to complete the request.
    init(_ input: Input)
    
    /// The input object to be used  to pass in values to the request
    associatedtype Input
    
    /// The associated response object to be parsed from the response.
    associatedtype Response: Decodable
    
    /// The decoder used to parse the network response.
    var jsonDecoder: JSONDecoder { get }
    
    /// The target's base url.
    var baseURL: URL { get }
    
    /// The path to be appended to base url to form the full url.
    var path: String { get }
    
    /// The parameters to be appended to the full formed url.
    var parameters: [String: String] { get }
    
    /// The headers to be used in the request.
    var headers: [String: String] { get }
    
    /// The http method used in the request.
    var method: SteeringRequestMethod { get }
    
    /// The body to be used in the request.
    var body: SteeringRequestBody { get }
    
    /// The validation to be applied to the status code.
    var validation: SteeringRequestValidation { get }
}

// MARK: - Internal Constructor
extension SteeringRequest {
    
    /// URL request constructed from the object.
    var urlRequest: URLRequest {
        
        // construct url request from base url
        var urlRequest = URLRequest(url: baseURL)
        
        // add path to url request
        add(path: path, to: &urlRequest)
        
        // add url components
        add(parameters: parameters, to: &urlRequest)
        
        // add headers to url request
        add(headers: headers, to: &urlRequest)
        
        // add http method type
        add(method: method, to: &urlRequest)
        
        // add http body
        add(body: body, to: &urlRequest)
        
        // return construct request
        return urlRequest
    }
}

// MARK: - Constructor Helpers
private extension SteeringRequest {
    
    /// Appends the given path to the request url.
    /// 
    /// - Parameter path: URL endpoint path to be added to the base url.
    /// - Parameter request: Inout url request being constructed.
    func add(path: String,
             to request: inout URLRequest) {
        
        request.url?.appendPathComponent(path)
    }
    
    /// Adds the http method type to the request.
    ///
    /// - Parameter method: HTTP method to be executed.
    /// - Parameter request: Inout url request being constructed.
    func add(method: SteeringRequestMethod,
             to request: inout URLRequest) {
        
        request.httpMethod = method.name
    }
    
    /// Encodes and appends the given request parameters to the request url.
    ///
    /// - Parameter parameters: Parameters to be added to the url query.
    /// - Parameter request: Inout url request being constructed.
    func add(parameters: [String: String],
             to request: inout URLRequest) {
        
        guard !parameters.isEmpty, let requestURL = request.url else {
            return
        }
        
        let items = parameters.map { URLQueryItem(name: $0, value: $1) }
        
        var urlComponents = URLComponents(url: requestURL, resolvingAgainstBaseURL: false)
        
        urlComponents?.queryItems = items
        
        request.url = urlComponents?.url
    }
    
    /// Adds given headers to the request.
    ///
    /// - Parameter headers: Headers to be added to the http header field.
    /// - Parameter request: Inout url request being constructed.
    func add(headers: [String: String],
             to request: inout URLRequest) {
        
        guard !headers.isEmpty else {
            return
        }
        
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
    
    /// Adds given body data to the request.
    ///
    /// - Parameter body: request body to be added.
    /// - Parameter request: Inout url request being constructed.
    func add(body: SteeringRequestBody,
             to request: inout URLRequest) {
        
        guard let data = body.data else {
            return
        }

        request.httpBody = data
    }
}
