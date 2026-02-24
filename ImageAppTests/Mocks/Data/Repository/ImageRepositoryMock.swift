//
//  ImageRepositoryMock.swift
//  ImageApp
//
//  Created by Adonys Rauda on 23/2/26.
//

import Foundation
@testable import ImageApp

final class MockImageRepository: ImageRepositoryType {
    var retrieveImagesCalledCount = 0
    var lastRequest: ImagesRequest?
    var shouldFail = false
    var customError: DomainError = .unauthorized
    var stubbedResponse: [ImageModel] = []

    func retrieveImages(imagesRequest: ImagesRequest) async throws -> [ImageModel] {
        retrieveImagesCalledCount += 1
        lastRequest = imagesRequest

        if shouldFail {
            throw customError
        }

        return stubbedResponse
    }

    // MARK: - Helpers

    func reset() {
        retrieveImagesCalledCount = 0
        lastRequest = nil
        shouldFail = false
        stubbedResponse = []
    }
}
