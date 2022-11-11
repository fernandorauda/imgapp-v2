//
//  ImageRepository.swift
//  ImageApp
//
//  Created by Adonys Rauda on 11/11/22.
//

import Foundation

final class ImageRepository: ImageRepositoryType {
    let dataSource: ImageDataSourceType
    
    init(dataSource: ImageDataSourceType = ImageDataSource()) {
        self.dataSource = dataSource
    }
    
    func retrieveImages(imagesRequest: ImagesRequest) async throws -> [ImageDto] {
        try await dataSource.retrieveImages(imagesRequest: imagesRequest)
    }
}
