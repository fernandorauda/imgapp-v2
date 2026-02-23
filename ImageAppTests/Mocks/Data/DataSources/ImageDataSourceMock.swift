//
//  ImageDataSourceMock.swift
//  ImageApp
//
//  Created by Adonys Rauda on 22/2/26.
//

import Foundation
@testable import ImageApp

final class ImageDataSourceMock: ImageDataSourceType {
    var retrieveImagesCalledCount = 0
    var shouldFail = false
    var customError = NetworkError.unknown(statusCode: 404)

    func retrieveImages(imagesRequest: ImagesRequest) async throws -> [ImageDto] {
        retrieveImagesCalledCount += 1
        if shouldFail {
            throw customError
        }
        
        return [];
    }
}
