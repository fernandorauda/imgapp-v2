//
//  UrlConfiguration.swift
//  ImageApp
//
//  Created by Adonys Rauda on 11/11/22.
//

import Foundation

enum ApiConfiguration {
    static let config = ApiDataNetworkingConfig(baseUrl: URL(string: "https://api.unsplash.com")!,
                                                headers: ["Content-Type": "application/json"],
                                                queryParameters: ["client_id": "QJmr3i1PslQ7mRiHACqzOkVouVBxv6lUxbRii8dW10g"]
    )
}
