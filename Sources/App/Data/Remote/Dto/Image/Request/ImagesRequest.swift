//
//  ImagesRequest.swift
//  ImageApp
//
//  Created by Adonys Rauda on 11/11/22.
//

import Foundation

struct ImagesRequest: Encodable {
    let page: Int
    let perPage: Int
    
    enum CodingKeys: String, CodingKey {
        case page
        case perPage = "per_page"
    }
}
