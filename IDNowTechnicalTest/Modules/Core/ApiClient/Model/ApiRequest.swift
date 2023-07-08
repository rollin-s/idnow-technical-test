//
//  IDApiRequest.swift
//  IDNowTechnicalTest
//
//  Created by sacha rollin on 06/07/2023.
//

import Foundation

/// Basic representation of a performed API Call
protocol APICall {
    var path: String { get }
    var method: String { get }
    var headers: [String: String]? { get }
    func body() throws -> Data?
}

/// Basic list of API errors
/// Must NOT contains any job errors, only raw API errors (!= 200)
enum APIError: Swift.Error {
    case invalidURL
    case httpCode(HTTPCode)
    case unexpectedResponse
}

extension APIError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL"
        case let .httpCode(code): return "Unexpected HTTP code: \(code)"
        case .unexpectedResponse: return "Unexpected response from the server"
        }
    }
}

extension APICall {
    
    /// Build an URL Request from the IDApiCall object.
    /// - Parameter baseURL: url of the API to perform the call
    /// - Returns: Correctly build URLRequest.
    func urlRequest(baseURL: String) throws -> URLRequest {
        guard let url = URL(string: baseURL + path) else {
            throw APIError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.allHTTPHeaderFields = headers
        request.httpBody = try body()
        return request
    }
}

typealias HTTPCode = Int
typealias HTTPCodes = Range<HTTPCode>

/// Add specific http codes error if needed
/// Might be usefull to catch very specific codes and not treat them as class code
extension HTTPCodes {
    static let success = 200 ..< 300
}
