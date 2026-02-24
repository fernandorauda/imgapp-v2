//
//  RetrieveImagesUseCaseMock.swift
//  ImageApp
//
//  Created by GitHub Copilot on 23/2/26.
//

import Foundation
@testable import ImageApp

final class MockRetrieveImagesUseCase: RetrieveImagesUseCaseType {
    var invokeCallCount = 0
    var lastRequest: ImagesRequest?
    var shouldFail = false
    var customError: DomainError = .unknown
    var stubbedResponse: [ImageModel] = []

    func invoke(request: ImagesRequest) async throws -> [ImageModel] {
        invokeCallCount += 1
        lastRequest = request
        if shouldFail {
            throw customError
        }
        return stubbedResponse
    }

    func reset() {
        invokeCallCount = 0
        lastRequest = nil
        shouldFail = false
        stubbedResponse = []
    }
}
