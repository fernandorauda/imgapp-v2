//
//  UrlMapper.swift
//  ImageApp
//
//  Created by Adonys Rauda on 11/11/22.
//

import Foundation

final class UrlMapper: Mapper {
    typealias FROM = UrlDto
    typealias TO = Url

    func call(object: FROM) -> TO {
        Url(
            regular: object.regular.orEmptyString(),
            full: object.full.orEmptyString(),
            small: object.small.orEmptyString(),
            medium: object.medium.orEmptyString()
        )
    }
}
