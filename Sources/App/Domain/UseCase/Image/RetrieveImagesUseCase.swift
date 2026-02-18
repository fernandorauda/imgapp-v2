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
        let result = try await repository.retrieveImages(imagesRequest: request)
        let imageMapper = ImageMapper()
        
        return result.map { imageMapper.call(object: $0) }
    }
}
