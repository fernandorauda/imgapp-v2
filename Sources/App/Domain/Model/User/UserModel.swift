//
//  User.swift
//  ImageApp
//
//  Created by Adonys Rauda on 11/11/22.
//

import Foundation

struct UserModel {
    let id: String
    let username: String
    let name: String
    let profileImage: UrlModel
    let totalLikes: Int
    let totalPhotos: Int
    let totalCollections: Int
    let location: String
    let bio: String
    
    init(
        id: String,
        username: String,
        name: String,
        profileImage: UrlModel,
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
    
    static func createEmptyInstance() -> UserModel {
        UserModel(id: "",
             username: "",
             name: "",
             profileImage: UrlModel.createEmptyInstance(),
             totalLikes: 0,
             totalPhotos: 0,
             totalCollections: 0,
             location: "",
             bio: "")
    }
}

