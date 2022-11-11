//
//  ImageDto.swift
//  ImageApp
//
//  Created by Adonys Rauda on 11/11/22.
//

import Foundation

class ImageDto: Codable {
    let id: String?
    let likes: Int?
    let desc: String?
    let urls: UrlDto?
    let user: UserDto?
    let createdAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case likes
        case desc = "description"
        case urls
        case user
        case createdAt = "created_at"
    }
}


