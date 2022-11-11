//
//  String+Optional.swift
//  ImageApp
//
//  Created by Adonys Rauda on 11/11/22.
//

import Foundation

extension Optional where Wrapped == String {
    func orEmptyString() -> String {
        return self ?? ""
    }
}

extension Optional where Wrapped == Int {
    func orZero() -> Int {
        return self ?? 0
    }
}
