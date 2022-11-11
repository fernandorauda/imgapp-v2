//
//  ImageDataSource.swift
//  ImageApp
//
//  Created by Adonys Rauda on 11/11/22.
//

import Foundation

protocol ImageDataSourceType {
    func retrieveImages(imagesRequest: ImagesRequest) async throws -> [ImageDto]
}

final class ImageDataSource: ImageDataSourceType {
    let apiProvider: ApiProvider
    
    init(apiProvider: ApiProvider = ApiProvider()) {
        self.apiProvider = apiProvider
    }
    
    func retrieveImages(imagesRequest: ImagesRequest) async throws -> [ImageDto] {
        let endpoint = ImageEndpoints.getImages(imageRequest: imagesRequest)
        let response = try await apiProvider.request(endpoint: endpoint)
        
        return response
    }
}
