//
//  Mapper.swift
//  ImageApp
//
//  Created by Adonys Rauda on 11/11/22.
//

import Foundation

protocol Mapper {
    associatedtype FROM: Codable
    associatedtype TO
    
    func call(object: FROM) -> TO
}
