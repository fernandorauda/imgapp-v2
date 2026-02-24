//
//  DI.swift
//  ImageApp
//
//  Created by Adonys Rauda on 22/2/26.
//

import Foundation

@MainActor
final class DIContainer: ObservableObject {
    // MARK: - Config Files
    
    private lazy var apiProvider: ApiProvider = {
        ApiProvider()
    }()
    
    // MARK: - Data Sources
    
    private lazy var imageDataSource: ImageDataSourceType = {
        ImageDataSource(apiProvider: apiProvider)
    }()
    
    // MARK: - Repositories
    
    private lazy var imageRepository: ImageRepositoryType = {
        ImageRepository(dataSource: imageDataSource)
    }()
    
    // MARK: - Use Cases
    
    private lazy var retrieveImagesUseCase: RetrieveImagesUseCaseType = {
        RetrieveImagesUseCase(repository: imageRepository)
    }()
    
    // MARK: - Public Accessors
    
    func makeImageListViewModel() -> ImageListViewModel {
        ImageListViewModel(retrieveImagesUseCase: retrieveImagesUseCase)
    }
    
}
