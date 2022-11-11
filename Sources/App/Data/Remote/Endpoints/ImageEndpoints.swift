//
//  ImageEndpoints.swift
//  ImageApp
//
//  Created by Adonys Rauda on 11/11/22.
//

import Foundation

struct ImageEndpoints {
    static func getImages(with imageRequest: ImagesRequest) -> Endpoint<[ImageDto]> {
        Endpoint(path: "photos",
                 method: .get,
                 queryParametersEncodable: imageRequest
        )
    }

    static func getImage(with id: String) -> Endpoint<ImageDto> {
        Endpoint(path: "photos/\(id)/",
                 method: .get
        )
    }
}
