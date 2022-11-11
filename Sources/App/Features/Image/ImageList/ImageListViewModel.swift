//
//  ImageListViewModel.swift
//  ImageApp
//
//  Created by Adonys Rauda on 11/11/22.
//

import Foundation

final class ImageListViewModel: ObservableObject {
    @Published var images: [Image] = []
    
    let retrieveImagesUseCase = RetrieveImagesUseCase()
    
    func retrieveImages() async {
        do {
            let request = ImagesRequest(page: 1, perPage: 100)
            let images = try await retrieveImagesUseCase.invoke(request: request)
            
            print(images.count)
            DispatchQueue.main.async {
                self.images = images
            }
        } catch {
            print(error)
        }
    }
}
