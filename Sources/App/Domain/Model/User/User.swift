//
//  User.swift
//  ImageApp
//
//  Created by Adonys Rauda on 11/11/22.
//

import Foundation

struct User: Codable {
    let id: String
    let username: String
    let name: String
    let profileImage: Url
    let totalLikes: Int
    let totalPhotos: Int
    let totalCollections: Int
    let location: String
    let bio: String
    
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
    
    init(
        id: String,
        username: String,
        name: String,
        profileImage: Url,
        totalLikes: Int,
        totalPhotos: Int,
        totalCollections: Int,
        location: String,
        bio: String
    ) {
        self.id = id
        self.username = username
        self.name = name
        self.profileImage = profileImage
        self.totalLikes = totalLikes
        self.totalPhotos = totalPhotos
        self.totalCollections = totalCollections
        self.location = location
        self.bio = bio
    }
    
    static func createEmptyInstance() -> User {
        User(id: "",
             username: "",
             name: "",
             profileImage: Url.createEmptyInstance(),
             totalLikes: 0,
             totalPhotos: 0,
             totalCollections: 0,
             location: "",
             bio: "")
    }
    
    func numberOfPhotos() -> String? {
        "\(totalPhotos)"
    }
    
    func numberOfLikes() -> String? {
        "\(totalLikes)"
    }
    
    func numberOfCollections() -> String? {
        "\(totalCollections)"
    }
}

