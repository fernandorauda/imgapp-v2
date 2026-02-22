//
//  Image+Presentation.swift
//  ImageApp
//
//  Extension for presentation logic of the Image model
//  Separates concerns according to Clean Architecture
//

import Foundation

// MARK: - Image Presentation Logic

extension ImageModel {
    
    /// Returns the number of likes formatted for display in UI
    /// - Returns: String with the number of likes, or empty if there are no likes
    var formattedLikes: String {
        likes == 0 ? "" : "\(likes)"
    }
    
    /// Returns the number of likes in abbreviated format (e.g: 1.2K, 3.5M)
    var formattedLikesShort: String {
        guard likes > 0 else { return "" }
        
        switch likes {
        case 1_000_000...:
            let millions = Double(likes) / 1_000_000.0
            return String(format: "%.1fM", millions)
        case 1_000...:
            let thousands = Double(likes) / 1_000.0
            return String(format: "%.1fK", thousands)
        default:
            return "\(likes)"
        }
    }
    
    /// Returns the date formatted as relative time (e.g: "2 days ago")
    var formattedDate: String {
        DateFormatterHelper.convertToFriendly(createdAt)
    }
    
    /// Returns the description or a default text if empty
    var displayDescription: String {
        desc.isEmpty ? "Sin descripción" : desc
    }
    
    /// Returns true if the image has likes
    var hasLikes: Bool {
        likes > 0
    }
}
