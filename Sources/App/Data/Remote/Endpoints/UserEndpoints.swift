//
//  UserEndpoints.swift
//  ImageApp
//
//  Created by Adonys Rauda on 11/11/22.
//

import Foundation

struct UserEndpoints {
    static func getUser(with username: String) -> Endpoint<UserDto> {
        Endpoint(path: "users/\(username)/",
                 method: .get
        )
    }
}
