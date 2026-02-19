//
//  DomainError.swift
//  ImageApp
//
//  Created by GitHub Copilot on 18/02/26.
//

import Foundation

/// Domain layer errors - User-friendly error messages
enum DomainError: Error {
    case network(NetworkError)
    case noData
    case unauthorized
    case serviceUnavailable
    case tooManyRequests
    case unknown
    
    /// User-friendly message in Spanish
    var userMessage: String {
        switch self {
        case .network(let networkError):
            return networkErrorMessage(networkError)
        case .noData:
            return "No se encontraron imágenes"
        case .unauthorized:
            return "Credenciales inválidas. Por favor, verifica tu configuración."
        case .serviceUnavailable:
            return "El servicio no está disponible en este momento. Intenta más tarde."
        case .tooManyRequests:
            return "Demasiadas solicitudes. Espera un momento e intenta de nuevo."
        case .unknown:
            return "Ocurrió un error inesperado. Por favor, intenta de nuevo."
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
            return "No hay conexión a internet. Verifica tu conexión e intenta de nuevo."
        case .timeout, .requestTimeout:
            return "La solicitud tardó demasiado. Verifica tu conexión e intenta de nuevo."
        case .unauthorized:
            return "Credenciales inválidas. Por favor, verifica tu API key."
        case .forbidden:
            return "No tienes permiso para acceder a este recurso."
        case .notFound:
            return "El recurso solicitado no existe."
        case .tooManyRequests:
            return "Demasiadas solicitudes. Espera un momento e intenta de nuevo."
        case .serverError:
            return "Error en el servidor. Por favor, intenta más tarde."
        case .badRequest:
            return "La solicitud es inválida. Por favor, intenta de nuevo."
        case .decodingFailed:
            return "Error al procesar la respuesta del servidor."
        case .cancelled:
            return "La solicitud fue cancelada."
        default:
            return "Ocurrió un error de red. Por favor, intenta de nuevo."
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
