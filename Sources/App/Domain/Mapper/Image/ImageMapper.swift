//
//  ImageMapper.swift
//  ImageApp
//
//  Created by Adonys Rauda on 11/11/22.
//

import Foundation

final class ImageMapper: Mapper {
    typealias FROM = ImageDto
    typealias TO = Image
    
    let urlMapper: UrlMapper = UrlMapper()
    let userMapper: UserMapper = UserMapper()
    
    func call(object: FROM) -> TO {
        var user = User.createEmptyInstance()
        var url = Url.createEmptyInstance()
        
        if let userInfo = object.user {
            user = userMapper.call(object: userInfo)
        }
        
        if let urlInfo = object.urls {
            url = urlMapper.call(object: urlInfo)
        }
        
        return Image(id: object.id.orEmptyString(),
                     likes: object.likes.orZero(),
                     urls: url,
                     user: user,
                     desc: object.desc.orEmptyString(),
                     createdAt: object.createdAt.orEmptyString())
    }
}
