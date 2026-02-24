//
//  UserMapper.swift
//  ImageApp
//
//  Created by Adonys Rauda on 11/11/22.
//

import Foundation

final class UserMapper: Mapper {
    let urlMapper: UrlMapper = UrlMapper()
    
    func call(object: UserDto) -> UserModel {
        var url = UrlModel.createEmptyInstance()
        
        if let profileImage = object.profileImage {
            url = urlMapper.call(object: profileImage)
        }
        
        return UserModel(id: object.id.orEmptyString(),
                    username: object.username.orEmptyString(),
                    name: object.name.orEmptyString(),
                    profileImage: url,
                    totalLikes: object.totalLikes.orZero(),
                    totalPhotos: object.totalPhotos.orZero(),
                    totalCollections: object.totalCollections.orZero(),
                    location: object.location.orEmptyString(),
                    bio: object.bio.orEmptyString())
    }
}
