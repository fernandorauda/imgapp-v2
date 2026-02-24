//
//  UrlMapper.swift
//  ImageApp
//
//  Created by Adonys Rauda on 11/11/22.
//

import Foundation

final class UrlMapper: Mapper {
    func call(object: UrlDto) -> UrlModel {
        UrlModel(
            regular: object.regular.orEmptyString(),
            full: object.full.orEmptyString(),
            small: object.small.orEmptyString(),
            medium: object.medium.orEmptyString()
        )
    }
}
