//
//  Image+Presentation.swift
//  ImageApp
//
//  Extension para lógica de presentación del modelo Image
//  Separa concerns según Clean Architecture
//

import Foundation

// MARK: - Image Presentation Logic

extension ImageModel {
    
    /// Retorna el número de likes formateado para mostrar en UI
    /// - Returns: String con el número de likes, o vacío si no hay likes
    var formattedLikes: String {
        likes == 0 ? "" : "\(likes)"
    }
    
    /// Retorna el número de likes con formato abreviado (ej: 1.2K, 3.5M)
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
    
    /// Retorna la fecha formateada de manera relativa (ej: "hace 2 días")
    var formattedDate: String {
        DateFormatterHelper.convertToFriendly(createdAt)
    }
    
    /// Retorna la descripción o un texto por defecto si está vacía
    var displayDescription: String {
        desc.isEmpty ? "Sin descripción" : desc
    }
    
    /// Retorna true si la imagen tiene likes
    var hasLikes: Bool {
        likes > 0
    }
}
