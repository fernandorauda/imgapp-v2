//
//  Image.swift
//  ImageApp
//
//  Created by Adonys Rauda on 11/11/22.
//

import Foundation

struct ImageModel: Hashable, Identifiable {
    let id: String
    let likes: Int
    let desc: String
    let urls: UrlModel
    let user: UserModel
    let createdAt: String
    
    init(id: String, likes: Int, urls: UrlModel, user: UserModel, desc: String, createdAt: String) {
        self.id = id
        self.likes = likes
        self.urls = urls
        self.user = user
        self.desc = desc
        self.createdAt = createdAt
    }
    
    static func == (lhs: ImageModel, rhs: ImageModel) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}


