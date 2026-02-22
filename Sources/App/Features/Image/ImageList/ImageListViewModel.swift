//
//  ImageListViewModel.swift
//  ImageApp
//
//  Created by Adonys Rauda on 11/11/22.
//

import Foundation

@MainActor
final class ImageListViewModel: ObservableObject {
    // MARK: - Published Properties
    
    @Published var images: [ImageModel] = []
    @Published var isLoading: Bool = false
    @Published var isLoadingMore: Bool = false
    
    // MARK: - Error State
    
    @Published var errorMessage: String?
    @Published var errorIcon: String = "exclamationmark.triangle"
    @Published var showError: Bool = false
    @Published var isRetryable: Bool = true
    @Published var currentError: DomainError?
    
    // MARK: - Private Properties
    
    private var currentPage: Int = 0
    private var canLoadMorePages: Bool = true
    private let perPage: Int = 20
    private var isCurrentlyLoading: Bool = false
    
    // MARK: - Dependencies

    private let retrieveImagesUseCase: RetrieveImagesUseCase
    
    // MARK: - Initializer
    init(retrieveImagesUseCase: RetrieveImagesUseCase) {
        self.retrieveImagesUseCase = retrieveImagesUseCase
    }
    
    // MARK: - Public Methods
    
    /// Retrieves the initial set of images (first page)
    func retrieveImages() async {
        guard !isCurrentlyLoading else { return }
        
        isLoading = true
        isCurrentlyLoading = true
        currentPage = 1
        clearError()
        
        do {
            let request = ImagesRequest(page: currentPage, perPage: perPage)
            let images = try await retrieveImagesUseCase.invoke(request: request)
            
            self.images = images
            self.canLoadMorePages = images.count >= perPage
        } catch let domainError as DomainError {
            handleError(domainError)
        } catch {
            handleError(DomainError.unknown)
        }
        
        isLoading = false
        isCurrentlyLoading = false
    }
    
    /// Loads the next page of images (infinite scroll)
    func loadMoreImagesIfNeeded() async {
        guard canLoadMorePages,
              !isCurrentlyLoading,
              !isLoading,
              !isLoadingMore else {
            return
        }
        
        isLoadingMore = true
        isCurrentlyLoading = true
        
        let nextPage = currentPage + 1
        
        do {
            let request = ImagesRequest(page: nextPage, perPage: perPage)
            let newImages = try await retrieveImagesUseCase.invoke(request: request)
            
            if !newImages.isEmpty {
                self.images.append(contentsOf: newImages)
                self.currentPage = nextPage
                
                self.canLoadMorePages = newImages.count >= perPage
            } else {
                self.canLoadMorePages = false
            }
        } catch let domainError as DomainError {
            #if DEBUG
            print("❌ Error loading more images: \(domainError.technicalDescription)")
            #endif
            self.canLoadMorePages = false
        } catch {
            #if DEBUG
            print("❌ Error loading more images: \(error)")
            #endif
            self.canLoadMorePages = false
        }
        
        isLoadingMore = false
        isCurrentlyLoading = false
    }
    
    /// Checks if we should load more content based on the current image
    func shouldLoadMore(currentImage: ImageModel?) -> Bool {
        guard let currentImage = currentImage,
              !images.isEmpty else { return false }
        
        guard let currentIndex = images.firstIndex(where: { $0.id == currentImage.id }) else {
            return false
        }
        
        let threshold = images.count - 3
        return currentIndex >= threshold
    }
    
    // MARK: - Error Handling
    
    /// Handle domain errors and update UI state
    private func handleError(_ error: DomainError) {
        self.currentError = error
        self.errorMessage = error.userMessage
        self.errorIcon = error.icon
        self.isRetryable = error.isRetryable
        self.showError = true
        
        #if DEBUG
        print("❌ Error: \(error.technicalDescription)")
        #endif
    }
    
    /// Clear error state
    func clearError() {
        self.currentError = nil
        self.errorMessage = nil
        self.showError = false
    }
    
    /// Retry the last failed operation
    func retryLastOperation() {
        Task {
            await retrieveImages()
        }
    }
}
