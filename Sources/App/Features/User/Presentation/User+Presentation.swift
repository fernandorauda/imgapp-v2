//
//  User+Presentation.swift
//  ImageApp
//
//  Extension para lógica de presentación del modelo User
//  Separa concerns según Clean Architecture
//

import Foundation

// MARK: - User Presentation Logic

extension UserModel {
    
    /// Retorna el número de fotos formateado para UI
    var formattedPhotos: String {
        "\(totalPhotos)"
    }
    
    /// Retorna el número de likes formateado para UI
    var formattedLikes: String {
        "\(totalLikes)"
    }
    
    /// Retorna el número de colecciones formateado para UI
    var formattedCollections: String {
        "\(totalCollections)"
    }
    
    /// Retorna el número de fotos con formato abreviado (ej: 1.2K)
    var formattedPhotosShort: String {
        formatNumber(totalPhotos)
    }
    
    /// Retorna el número de likes con formato abreviado (ej: 3.5M)
    var formattedLikesShort: String {
        formatNumber(totalLikes)
    }
    
    /// Retorna el número de colecciones con formato abreviado
    var formattedCollectionsShort: String {
        formatNumber(totalCollections)
    }
    
    /// Retorna el nombre de usuario con @ si no lo tiene
    var displayUsername: String {
        username.hasPrefix("@") ? username : "@\(username)"
    }
    
    /// Retorna la bio o un texto por defecto si está vacía
    var displayBio: String {
        bio.isEmpty ? "Sin biografía" : bio
    }
    
    /// Retorna la ubicación o un texto por defecto si está vacía
    var displayLocation: String {
        location.isEmpty ? "Ubicación no disponible" : location
    }
    
    /// Indica si el usuario tiene estadísticas
    var hasStatistics: Bool {
        totalPhotos > 0 || totalLikes > 0 || totalCollections > 0
    }
    
    // MARK: - Private Helpers
    
    /// Formatea un número con abreviación (K, M)
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
