//
//  Url.swift
//  ImageApp
//
//  Created by Adonys Rauda on 11/11/22.
//

import Foundation

struct UrlModel {
    let regular: String
    let full: String
    let small: String
    let medium: String
    
    init(
        regular: String,
        full: String,
        small: String,
        medium: String
    ) {
        self.regular = regular
        self.full = full
        self.small = small
        self.medium = medium
    }
    
    static func createEmptyInstance() -> UrlModel {
        UrlModel(
            regular: "",
            full: "",
            small: "",
            medium: ""
        )
    }
}
