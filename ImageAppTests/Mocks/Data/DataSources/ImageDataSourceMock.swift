//
//  ImageDataSourceMock.swift
//  ImageApp
//
//  Created by Adonys Rauda on 22/2/26.
//

import Foundation
@testable import ImageApp

final class MockImageDataSource: ImageDataSourceType {
    var retrieveImagesCalledCount = 0
    var shouldFail = false
    var customError = NetworkError.unauthorized
    var stubbedResponse: [ImageDto] = []

    func retrieveImages(imagesRequest: ImagesRequest) async throws -> [ImageDto] {
        retrieveImagesCalledCount += 1
        if shouldFail {
            throw customError
        }
        
        return stubbedResponse;
    }
}
