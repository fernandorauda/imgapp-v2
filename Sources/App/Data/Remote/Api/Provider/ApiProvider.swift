//
//  ApiProvider.swift
//  ImageApp
//
//  Created by Adonys Rauda on 11/11/22.
//

import Foundation

protocol ApiProviderType {
    func request<T: Decodable, E: ResponseRequestable>(endpoint: E) async throws -> T where E.Response == T
}

struct ApiProvider: ApiProviderType {
    
    private let config: NetworkConfigurable

    init(config: NetworkConfigurable = ApiConfiguration.config) {
        self.config = config
    }
    
    func request<T: Decodable, E: ResponseRequestable>(endpoint: E) async throws -> T where E.Response == T {
        let request = try endpoint.urlRequest(networkConfig: config)
        
        let (data, response): (Data, URLResponse)
        
        do {
            (data, response) = try await URLSession.shared.data(for: request)
        } catch let urlError as URLError {
            throw mapURLError(urlError)
        } catch {
            throw NetworkError.unknown(statusCode: -1)
        }
        
        // Validate HTTP response
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        #if DEBUG
            print("RESPONSE: \(httpResponse.statusCode) - \(httpResponse.debugDescription)")
            if let jsonResponse = String(data: data, encoding: .utf8) {
                print("**********************************")
                print("Response JSON : \(jsonResponse)")
                print("**********************************")
            }
        #endif
        
        try validateStatusCode(httpResponse.statusCode)
        
        do {
            let result: T = try endpoint.responseDecoder.decode(data)
            return result
        } catch {
            throw NetworkError.decodingFailed(error)
        }
    }
    
    // MARK: - Private Helpers
    
    private func validateStatusCode(_ statusCode: Int) throws {
        switch statusCode {
        case 200...299:
            return
        case 400:
            throw NetworkError.badRequest
        case 401:
            throw NetworkError.unauthorized
        case 403:
            throw NetworkError.forbidden
        case 404:
            throw NetworkError.notFound
        case 408:
            throw NetworkError.requestTimeout
        case 429:
            throw NetworkError.tooManyRequests
        case 500...599:
            throw NetworkError.serverError
        default:
            throw NetworkError.unknown(statusCode: statusCode)
        }
    }
    
    private func mapURLError(_ error: URLError) -> NetworkError {
        switch error.code {
        case .notConnectedToInternet, .networkConnectionLost:
            return .noInternetConnection
        case .timedOut:
            return .timeout
        case .cancelled:
            return .cancelled
        case .cannotFindHost, .cannotConnectToHost, .dnsLookupFailed:
            return .noInternetConnection
        default:
            return .unknown(statusCode: error.errorCode)
        }
    }
}
