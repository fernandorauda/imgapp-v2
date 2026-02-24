//
//  ImageRepository.swift
//  ImageApp
//
//  Created by Adonys Rauda on 11/11/22.
//

import Foundation

final class ImageRepository: ImageRepositoryType {
    private let dataSource: ImageDataSourceType
    
    init(dataSource: ImageDataSourceType) {
        self.dataSource = dataSource
    }
    
    func retrieveImages(imagesRequest: ImagesRequest) async throws -> [ImageModel] {
        do {
            let imageMapper = ImageMapper()
            let result = try await dataSource.retrieveImages(imagesRequest: imagesRequest)
            
            return result.map { imageMapper.call(object: $0) }
        } catch let networkError as NetworkError {
            throw networkError.toDomainError()
        } catch {
            throw DomainError.unknown
        }
    }
}
