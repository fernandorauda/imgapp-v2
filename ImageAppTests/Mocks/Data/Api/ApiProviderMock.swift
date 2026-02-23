//
//  ApiProviderMock.swift
//  ImageApp
//
//  Created by Adonys Rauda on 22/2/26.
//

import Foundation
@testable import ImageApp

final class MockApiProvider: ApiProviderType {
    var requestCallCount = 0
    var lastEndpoint: Any?
    
    // MARK: - Stubs
    
    var shouldFail = false
    var customError = NetworkError.unknown(statusCode: 404)
    var stubbedResponse: Any?
    
    // MARK: - Impl
    func request<T, E>(endpoint: E) async throws -> T where T : Decodable, T == E.Response, E : ResponseRequestable {
        
        requestCallCount += 1
        lastEndpoint = endpoint
        
        if shouldFail {
            throw customError
        }
        
        guard let response = stubbedResponse as? T else {
            fatalError("🚨 Mock Setup Error: You forgot to configure 'stubbedResponse' or the type does not match \(T.self)")
        }
        
        return response
    }
    
    // MARK: - Helpers
    
    func reset() {
        requestCallCount = 0
        lastEndpoint = nil
        shouldFail = false
        stubbedResponse = nil
    }
}
