//
//  UserDto.swift
//  ImageApp
//
//  Created by Adonys Rauda on 11/11/22.
//

import Foundation

struct UserDto: Codable {
    let id: String?
    let username: String?
    let name: String?
    let profileImage: UrlDto?
    let totalLikes: Int?
    let totalPhotos: Int?
    let totalCollections: Int?
    let location: String?
    let bio: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case username
        case name
        case location
        case bio
        case profileImage = "profile_image"
        case totalLikes = "total_likes"
        case totalPhotos = "total_photos"
        case totalCollections = "total_collections"
    }
}

