//
//  RetrieveImagesUseCase.swift
//  ImageApp
//
//  Created by Adonys Rauda on 11/11/22.
//

import Foundation

final class RetrieveImagesUseCase {
    let repository: ImageRepositoryType
    
    init(repository: ImageRepositoryType = ImageRepository()) {
        self.repository = repository
    }
    
    func invoke(request: ImagesRequest) async throws -> [ImageModel] {
        do {
            let result = try await repository.retrieveImages(imagesRequest: request)
            
            // Check if result is empty
            guard !result.isEmpty else {
                throw DomainError.noData
            }
            
            let imageMapper = ImageMapper()
            return result.map { imageMapper.call(object: $0) }
        } catch let domainError as DomainError {
            // Propagate domain errors
            throw domainError
        } catch {
            // Unknown error - wrap it
            throw DomainError.unknown
        }
    }
}
