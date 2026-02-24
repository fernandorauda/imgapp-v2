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
    private let apiProvider: ApiProviderType
    
    init(apiProvider: ApiProviderType) {
        self.apiProvider = apiProvider
    }
    
    func retrieveImages(imagesRequest: ImagesRequest) async throws -> [ImageDto] {
        do {
            let endpoint = ImageEndpoints.getImages(imageRequest: imagesRequest)
            let response: [ImageDto] = try await apiProvider.request(endpoint: endpoint)
            
            return response
        } catch let networkError as NetworkError {
            throw networkError
        } catch {
            throw NetworkError.unknown(statusCode: -1)
        }
    }
}
