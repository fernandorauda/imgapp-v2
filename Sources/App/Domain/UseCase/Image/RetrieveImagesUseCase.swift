//
//  RetrieveImagesUseCase.swift
//  ImageApp
//
//  Created by Adonys Rauda on 11/11/22.
//

import Foundation

protocol RetrieveImagesUseCaseType {
    func invoke(request: ImagesRequest) async throws -> [ImageModel]
}

final class RetrieveImagesUseCase: RetrieveImagesUseCaseType {
    let repository: ImageRepositoryType
    
    init(repository: ImageRepositoryType) {
        self.repository = repository
    }
    
    func invoke(request: ImagesRequest) async throws -> [ImageModel] {
        return try await repository.retrieveImages(imagesRequest: request)
    }
}
