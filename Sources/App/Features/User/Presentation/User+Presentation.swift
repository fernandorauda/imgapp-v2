//
//  User+Presentation.swift
//  ImageApp
//
//  Extension for presentation logic of the User model
//  Separates concerns according to Clean Architecture
//

import Foundation

// MARK: - User Presentation Logic

extension UserModel {
    
    /// Returns the number of photos formatted for UI
    var formattedPhotos: String {
        "\(totalPhotos)"
    }
    
    /// Returns the number of likes formatted for UI
    var formattedLikes: String {
        "\(totalLikes)"
    }
    
    /// Returns the number of collections formatted for UI
    var formattedCollections: String {
        "\(totalCollections)"
    }
    
    /// Returns the number of photos in abbreviated format (e.ge.g: 1.2K)
    var formattedPhotosShort: String {
        formatNumber(totalPhotos)
    }
    
    /// Returns the number of likes in abbreviated format (e.g: 3.5M)
    var formattedLikesShort: String {
        formatNumber(totalLikes)
    }
    
    /// Returns the number of collections in abbreviated format
    var formattedCollectionsShort: String {
        formatNumber(totalCollections)
    }
    
    /// Returns the username with @ if it doesn't have it
    var displayUsername: String {
        username.hasPrefix("@") ? username : "@\(username)"
    }
    
    /// Returns the bio or default text if empty
    var displayBio: String {
        bio.isEmpty ? "Sin biografía" : bio
    }
    
    /// Returns the location or default text if empty
    var displayLocation: String {
        location.isEmpty ? "Ubicación no disponible" : location
    }
    
    /// Indicates if the user has statistics
    var hasStatistics: Bool {
        totalPhotos > 0 || totalLikes > 0 || totalCollections > 0
    }
    
    // MARK: - Private Helpers
    
    /// Formats a number with abbreviation (K, M)
    private func formatNumber(_ number: Int) -> String {
        switch number {
        case 1_000_000...:
            let millions = Double(number) / 1_000_000.0
            return String(format: "%.1fM", millions)
        case 1_000...:
            let thousands = Double(number) / 1_000.0
            return String(format: "%.1fK", thousands)
        default:
            return "\(number)"
        }
    }
}
