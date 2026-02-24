//
//  LocalizationKeys.swift
//  ImageApp
//
//  Centralized localization keys.
//  Usage in SwiftUI views: Text(L10n.Navigation.imagesTitle)
//  Usage in Swift code:    L10n.Error.unexpected.value
//

import SwiftUI

// MARK: - L10n Namespace

enum L10n {

    // MARK: - Navigation
    enum Navigation {
        static let imagesTitle = LocalizedStringKey("navigation.images.title")
    }

    // MARK: - Image List
    enum ImageList {
        static let emptyMessage = LocalizedStringKey("image_list.empty.message")
        static let loading = LocalizedStringKey("image_list.loading")
    }

    // MARK: - Error
    enum Error {
        static let title = LocalizedStringKey("error.title")
        static let unexpected = LocalizedStringKey("error.unexpected")
        static let noInternet = LocalizedStringKey("error.no_internet")
        static let timeout = LocalizedStringKey("error.timeout")
        static let unauthorized = LocalizedStringKey("error.unauthorized")
        static let forbidden = LocalizedStringKey("error.forbidden")
        static let notFound = LocalizedStringKey("error.not_found")
        static let rateLimit = LocalizedStringKey("error.rate_limit")
        static let server = LocalizedStringKey("error.server")
        static let badRequest = LocalizedStringKey("error.bad_request")
        static let decoding = LocalizedStringKey("error.decoding")
        static let cancelled = LocalizedStringKey("error.cancelled")
        static let networkGeneric = LocalizedStringKey("error.network_generic")
        static let serviceUnavailable = LocalizedStringKey("error.service_unavailable")
        static let noImages = LocalizedStringKey("error.no_images")
    }

    // MARK: - Actions
    enum Action {
        static let retry = LocalizedStringKey("action.retry")
        static let cancel = LocalizedStringKey("action.cancel")
        static let ok = LocalizedStringKey("action.ok")
    }

    // MARK: - Image Presentation
    enum Image {
        static let noDescription = LocalizedStringKey("image.no_description")
    }

    // MARK: - User Presentation
    enum User {
        static let noBio = LocalizedStringKey("user.no_bio")
        static let noLocation = LocalizedStringKey("user.no_location")
    }
}

// MARK: - String extension for non-View usage

extension String {
    /// Returns the localized value for a given key.
    /// Use this outside SwiftUI views where LocalizedStringKey is not accepted.
    static func localized(_ key: String) -> String {
        NSLocalizedString(key, comment: "")
    }
}
