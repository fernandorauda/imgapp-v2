//
//  ImageRepositoryType.swift
//  ImageApp
//
//  Created by Adonys Rauda on 11/11/22.
//

import Foundation

protocol ImageRepositoryType {
    func retrieveImages(imagesRequest: ImagesRequest) async throws -> [ImageModel]
}
