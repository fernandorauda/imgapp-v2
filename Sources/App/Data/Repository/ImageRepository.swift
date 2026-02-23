//
//  ImageRepository.swift
//  ImageApp
//
//  Created by Adonys Rauda on 11/11/22.
//

import Foundation

final class ImageRepository: ImageRepositoryType {
    let dataSource: ImageDataSourceType
    
    init(dataSource: ImageDataSourceType) {
        self.dataSource = dataSource
    }
    
    func retrieveImages(imagesRequest: ImagesRequest) async throws -> [ImageDto] {
        do {
            return try await dataSource.retrieveImages(imagesRequest: imagesRequest)
        } catch let networkError as NetworkError {
            // Convert NetworkError to DomainError at the boundary
            throw networkError.toDomainError()
        } catch {
            // Unknown error
            throw DomainError.unknown
        }
    }
}
