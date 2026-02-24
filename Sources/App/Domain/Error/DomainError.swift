//
//  DomainError.swift
//  ImageApp
//
//  Created by GitHub Copilot on 18/02/26.
//

import Foundation

/// Domain layer errors - User-friendly error messages
enum DomainError: Error, Equatable {
    case network(NetworkError)
    case noData
    case unauthorized
    case serviceUnavailable
    case tooManyRequests
    case unknown
    
    /// User-friendly localized message
    var userMessage: String {
        switch self {
        case .network(let networkError):
            return networkErrorMessage(networkError)
        case .noData:
            return .localized("error.no_images")
        case .unauthorized:
            return .localized("error.unauthorized")
        case .serviceUnavailable:
            return .localized("error.service_unavailable")
        case .tooManyRequests:
            return .localized("error.rate_limit")
        case .unknown:
            return .localized("error.unexpected")
        }
    }
    
    /// Technical description for logging
    var technicalDescription: String {
        switch self {
        case .network(let networkError):
            return "Network error: \(networkError.technicalDescription)"
        case .noData:
            return "No data available"
        case .unauthorized:
            return "Unauthorized access"
        case .serviceUnavailable:
            return "Service unavailable"
        case .tooManyRequests:
            return "Rate limit exceeded"
        case .unknown:
            return "Unknown domain error"
        }
    }
    
    /// Icon for UI display
    var icon: String {
        switch self {
        case .network(let networkError):
            if case .noInternetConnection = networkError {
                return "wifi.slash"
            }
            return "exclamationmark.triangle"
        case .noData:
            return "photo.on.rectangle.angled"
        case .unauthorized:
            return "lock.shield"
        case .serviceUnavailable:
            return "xmark.icloud"
        case .tooManyRequests:
            return "clock.badge.exclamationmark"
        case .unknown:
            return "exclamationmark.circle"
        }
    }
    
    /// Whether the user can retry this error
    var isRetryable: Bool {
        switch self {
        case .network(let networkError):
            switch networkError {
            case .noInternetConnection, .timeout, .serverError, .requestTimeout:
                return true
            case .unauthorized, .forbidden:
                return false
            default:
                return true
            }
        case .serviceUnavailable, .tooManyRequests, .unknown:
            return true
        case .unauthorized:
            return false
        case .noData:
            return true
        }
    }
    
    // MARK: - Private Helpers
    
    private func networkErrorMessage(_ error: NetworkError) -> String {
        switch error {
        case .noInternetConnection:
            return .localized("error.no_internet")
        case .timeout, .requestTimeout:
            return .localized("error.timeout")
        case .unauthorized:
            return .localized("error.unauthorized")
        case .forbidden:
            return .localized("error.forbidden")
        case .notFound:
            return .localized("error.not_found")
        case .tooManyRequests:
            return .localized("error.rate_limit")
        case .serverError:
            return .localized("error.server")
        case .badRequest:
            return .localized("error.bad_request")
        case .decodingFailed:
            return .localized("error.decoding")
        case .cancelled:
            return .localized("error.cancelled")
        default:
            return .localized("error.network_generic")
        }
    }
}

extension DomainError: LocalizedError {
    var errorDescription: String? {
        return userMessage
    }
}

// MARK: - NetworkError to DomainError Conversion

extension NetworkError {
    /// Convert NetworkError to DomainError
    func toDomainError() -> DomainError {
        switch self {
        case .unauthorized, .forbidden:
            return .unauthorized
        case .tooManyRequests:
            return .tooManyRequests
        case .serverError, .requestTimeout, .timeout:
            return .serviceUnavailable
        case .noData, .notFound:
            return .noData
        default:
            return .network(self)
        }
    }
}
