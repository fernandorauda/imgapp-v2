//
//  ImageListViewModel.swift
//  ImageApp
//
//  Created by Adonys Rauda on 11/11/22.
//

import Foundation

final class ImageListViewModel: ObservableObject {
    @Published var images: [Image] = []
    @Published var isLoading: Bool = false
    
    let retrieveImagesUseCase = RetrieveImagesUseCase()
    
    func retrieveImages() async {
        isLoading = true
        do {
            let request = ImagesRequest(page: 1, perPage: 100)
            let images = try await retrieveImagesUseCase.invoke(request: request)
            
            DispatchQueue.main.async {
                self.isLoading = false
                self.images = images
            }
        } catch {
            print(error)
        }
    }
}
