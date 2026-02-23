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
    let apiProvider: ApiProviderType
    
    init(apiProvider: ApiProviderType) {
        self.apiProvider = apiProvider
    }
    
    func retrieveImages(imagesRequest: ImagesRequest) async throws -> [ImageDto] {
        do {
            let endpoint = ImageEndpoints.getImages(imageRequest: imagesRequest)
            let response: [ImageDto] = try await apiProvider.request(endpoint: endpoint)
            
            return response
        } catch let networkError as NetworkError {
            // Propagate NetworkError to upper layers
            throw networkError
        } catch {
            // Unknown error - wrap it
            throw NetworkError.unknown(statusCode: -1)
        }
    }
}
