//
//  Image.swift
//  ImageApp
//
//  Created by Adonys Rauda on 11/11/22.
//

import Foundation

class Image: Codable, Hashable, Identifiable {
    let id: String
    let likes: Int
    let desc: String
    let urls: Url
    let user: User
    let createdAt: String
    
    init(id: String, likes: Int, urls: Url, user: User, desc: String, createdAt: String) {
        self.id = id
        self.likes = likes
        self.urls = urls
        self.user = user
        self.desc = desc
        self.createdAt = createdAt
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case likes
        case desc = "description"
        case urls
        case user
        case createdAt = "created_at"
    }
    
    static func == (lhs: Image, rhs: Image) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    func numberOfLikes() -> String? {
        return likes == 0 ? "" : "\(likes)"
    }
}


struct DateFormatterDefault {
    let date: String
    
    init(date: String) {
        self.date = date
    }
    
    func convertToFriendly() -> String {
        let formatter = RelativeDateTimeFormatter()
        let dateFormatCoordinate = DateFormatter()
        formatter.dateTimeStyle = .named
        dateFormatCoordinate.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        if let d = dateFormatCoordinate.date(from: date) {
            let timeInterval = d.timeIntervalSinceNow
            return formatter.localizedString(fromTimeInterval: timeInterval)
        }
        return ""
    }
    
}

