//
//  DateFormatterHelper.swift
//  ImageApp
//
//  Date formatting utilities for the app
//

import Foundation

/// Helper para formatear fechas de manera consistente en toda la app
struct DateFormatterHelper {
    
    // MARK: - ISO8601 Formatter
    
    /// Formateador ISO8601 para parsear fechas del backend
    private static let iso8601Formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()
    
    // MARK: - Relative Date Formatter
    
    /// Formateador para fechas relativas (ej: "hace 2 días")
    private static let relativeDateFormatter: RelativeDateTimeFormatter = {
        let formatter = RelativeDateTimeFormatter()
        formatter.dateTimeStyle = .named
        formatter.locale = Locale.current
        return formatter
    }()
    
    // MARK: - Public Methods
    
    /// Convierte un string ISO8601 a una fecha relativa legible
    /// - Parameter dateString: String en formato ISO8601 (ej: "2024-01-15T10:30:00Z")
    /// - Returns: String con fecha relativa (ej: "hace 2 días") o string vacío si falla
    static func convertToFriendly(_ dateString: String) -> String {
        guard let date = iso8601Formatter.date(from: dateString) else {
            return ""
        }
        return relativeDateFormatter.localizedString(for: date, relativeTo: Date())
    }
    
    /// Convierte un string ISO8601 a Date
    /// - Parameter dateString: String en formato ISO8601
    /// - Returns: Date opcional
    static func parseISO8601(_ dateString: String) -> Date? {
        return iso8601Formatter.date(from: dateString)
    }
    
    /// Formatea una fecha a un string legible
    /// - Parameters:
    ///   - date: La fecha a formatear
    ///   - style: Estilo de formato (short, medium, long, full)
    /// - Returns: String formateado
    static func format(_ date: Date, style: DateFormatter.Style = .medium) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = style
        formatter.timeStyle = .none
        formatter.locale = Locale.current
        return formatter.string(from: date)
    }
}
