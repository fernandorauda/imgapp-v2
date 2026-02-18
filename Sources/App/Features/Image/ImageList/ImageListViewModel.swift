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
    
    // MARK: - Private Properties
    private var currentPage: Int = 0
    private var canLoadMorePages: Bool = true
    private let perPage: Int = 20
    private var isCurrentlyLoading: Bool = false
    
    // MARK: - Dependencies
    let retrieveImagesUseCase = RetrieveImagesUseCase()
    
    // MARK: - Public Methods
    
    /// Retrieves the initial set of images (first page)
    func retrieveImages() async {
        // Prevent multiple simultaneous loads
        guard !isCurrentlyLoading else { return }
        
        isLoading = true
        isCurrentlyLoading = true
        currentPage = 1
        
        do {
            let request = ImagesRequest(page: currentPage, perPage: perPage)
            let images = try await retrieveImagesUseCase.invoke(request: request)
            
            self.images = images
            self.canLoadMorePages = images.count >= perPage
        } catch {
            print("❌ Error loading images: \(error)")
            self.canLoadMorePages = false
        }
        
        isLoading = false
        isCurrentlyLoading = false
    }
    
    /// Loads the next page of images (infinite scroll)
    func loadMoreImagesIfNeeded() async {
        // Guard conditions to prevent unnecessary loads
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
            
            // Only update if we received images
            if !newImages.isEmpty {
                self.images.append(contentsOf: newImages)
                self.currentPage = nextPage
                
                // If we received fewer images than requested, we've reached the end
                self.canLoadMorePages = newImages.count >= perPage
            } else {
                // No more images available
                self.canLoadMorePages = false
            }
        } catch {
            print("❌ Error loading more images: \(error)")
            self.canLoadMorePages = false
        }
        
        isLoadingMore = false
        isCurrentlyLoading = false
    }
    
    /// Checks if we should load more content based on the current image
    func shouldLoadMore(currentImage: ImageModel?) -> Bool {
        guard let currentImage = currentImage,
              !images.isEmpty else { return false }
        
        // Trigger load when we're near the end (last 3 items)
        guard let currentIndex = images.firstIndex(where: { $0.id == currentImage.id }) else {
            return false
        }
        
        let threshold = images.count - 3
        return currentIndex >= threshold
    }
}
