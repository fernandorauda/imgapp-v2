//
//  NetworkError.swift
//  ImageApp
//
//  Created by GitHub Copilot on 18/02/26.
//

import Foundation

/// Network layer errors with HTTP status code handling
enum NetworkError: Error, Equatable {
    case invalidURL
    case invalidResponse
    case noData
    case decodingFailed(Error)
    case encodingFailed(Error)
    
    // HTTP Status Code Errors
    case unauthorized           // 401
    case forbidden              // 403
    case notFound               // 404
    case requestTimeout         // 408
    case tooManyRequests        // 429
    case serverError            // 500-599
    case badRequest             // 400
    case unknown(statusCode: Int)
    
    // Connection Errors
    case noInternetConnection
    case timeout
    case cancelled
    
    /// HTTP status code if available
    var statusCode: Int? {
        switch self {
        case .badRequest: return 400
        case .unauthorized: return 401
        case .forbidden: return 403
        case .notFound: return 404
        case .requestTimeout: return 408
        case .tooManyRequests: return 429
        case .serverError: return 500
        case .unknown(let code): return code
        default: return nil
        }
    }
    
    /// Technical description for debugging
    var technicalDescription: String {
        switch self {
        case .invalidURL:
            return "The URL is malformed or invalid"
        case .invalidResponse:
            return "The server response is invalid"
        case .noData:
            return "No data received from server"
        case .decodingFailed(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        case .encodingFailed(let error):
            return "Failed to encode request: \(error.localizedDescription)"
        case .unauthorized:
            return "Unauthorized - Invalid or missing API key (401)"
        case .forbidden:
            return "Forbidden - Access denied (403)"
        case .notFound:
            return "Resource not found (404)"
        case .requestTimeout:
            return "Request timeout (408)"
        case .tooManyRequests:
            return "Too many requests - Rate limit exceeded (429)"
        case .serverError:
            return "Server error (500-599)"
        case .badRequest:
            return "Bad request - Invalid parameters (400)"
        case .unknown(let statusCode):
            return "Unknown error with status code: \(statusCode)"
        case .noInternetConnection:
            return "No internet connection available"
        case .timeout:
            return "Request timed out"
        case .cancelled:
            return "Request was cancelled"
        }
    }
    
    static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidURL, .invalidURL),
             (.invalidResponse, .invalidResponse),
             (.noData, .noData),
             (.unauthorized, .unauthorized),
             (.forbidden, .forbidden),
             (.notFound, .notFound),
             (.requestTimeout, .requestTimeout),
             (.tooManyRequests, .tooManyRequests),
             (.serverError, .serverError),
             (.badRequest, .badRequest),
             (.noInternetConnection, .noInternetConnection),
             (.timeout, .timeout),
             (.cancelled, .cancelled):
            return true
        case let (.unknown(a), .unknown(b)):
            return a == b
        case (.decodingFailed, .decodingFailed), (.encodingFailed, .encodingFailed):
            // No se compara el error asociado, solo el tipo de error
            return true
        default:
            return false
        }
    }
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        return technicalDescription
    }
}
