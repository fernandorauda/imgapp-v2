//
//  NetworkConfigurable.swift
//  ImageApp
//
//  Created by Adonys Rauda on 11/11/22.
//

import Foundation

public protocol NetworkConfigurable {
    var baseUrl: URL { get }
    var headers: [String: String] { get }
    var queryParameters: [String: String] { get }
}

public struct ApiDataNetworkingConfig: NetworkConfigurable {
    public let baseUrl: URL
    public let headers: [String: String]
    public let queryParameters: [String: String]

    public init(baseUrl: URL,
                headers: [String: String] = [:],
                queryParameters: [String: String] = [:]) {
        self.baseUrl = baseUrl
        self.headers = headers
        self.queryParameters = queryParameters
    }
}
