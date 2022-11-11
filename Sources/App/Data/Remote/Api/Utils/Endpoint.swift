//
//  Endpoint.swift
//  ImageApp
//
//  Created by Adonys Rauda on 11/11/22.
//

import Foundation

public enum HTTPMethodType: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
}

public enum BodyEnconding {
    case jsonSerializationData
    case stringEncodingAscii
}

public protocol ResponseRequestable: Requestable {
    associatedtype Response

    var responseDecoder: ResponseDecoder { get }
}

public protocol Requestable {
    var path: String { get }
    var isFullPath: Bool { get }
    var method: HTTPMethodType { get }
    var headerParameters: [String: String] { get }
    var queryParametersEncodable: Encodable? { get }
    var bodyParamatersEncodable: Encodable? { get }
    var bodyParameters: [String: Any] { get }

    func urlRequest(networkConfig: NetworkConfigurable) throws -> URLRequest
}

public protocol ResponseDecoder {
    func decode<T: Decodable>(_ data: Data) throws -> T
}

enum RequestGenerationError: Error {
    case components
}

public class Endpoint<R>: ResponseRequestable {

    public typealias Response = R

    public let path: String
    public let isFullPath: Bool
    public let method: HTTPMethodType
    public let headerParameters: [String: String]
    public let queryParametersEncodable: Encodable?
    public let bodyParamatersEncodable: Encodable?
    public let bodyParameters: [String: Any]
    public let responseDecoder: ResponseDecoder

    init(path: String,
         isFullPath: Bool = false,
         method: HTTPMethodType,
         headerParameters: [String: String] = [:],
         queryParametersEncodable: Encodable? = nil,
         bodyParametersEncondable: Encodable? = nil,
         bodyParameters: [String: Any] = [:],
         responseDecoder: ResponseDecoder = JSONResponseDecoder()) {
        self.path = path
        self.isFullPath = isFullPath
        self.method = method
        self.headerParameters = headerParameters
        self.queryParametersEncodable = queryParametersEncodable
        self.bodyParamatersEncodable = bodyParametersEncondable
        self.bodyParameters = bodyParameters
        self.responseDecoder = responseDecoder
    }
}

extension Requestable {

    func url(with config: NetworkConfigurable) throws -> URL {

        let baseURL = config.baseUrl.absoluteString.last != "/" ?
        config.baseUrl.absoluteString + "/" :
        config.baseUrl.absoluteString

        let endpoint = isFullPath ? path : baseURL.appending(path)

        guard var urlComponents = URLComponents(string: endpoint) else { throw RequestGenerationError.components }
        var urlQueryItems = [URLQueryItem]()

        let queryParameters = try queryParametersEncodable?.toDictionary() ?? [:]
        queryParameters.forEach {
            urlQueryItems.append(URLQueryItem(name: $0.key, value: "\($0.value)"))
        }
        config.queryParameters.forEach {
            urlQueryItems.append(URLQueryItem(name: $0.key, value: $0.value))
        }
        urlComponents.queryItems = !urlQueryItems.isEmpty ? urlQueryItems : nil
        guard let url = urlComponents.url else { throw RequestGenerationError.components }
        return url
    }

    public func urlRequest(networkConfig: NetworkConfigurable) throws -> URLRequest {

        let url = try self.url(with: networkConfig)
        var urlRequest = URLRequest(url: url)
        var allHeaders: [String: String] = networkConfig.headers
        headerParameters.forEach { allHeaders.updateValue($1, forKey: $0) }

        let bodyParamaters = try bodyParamatersEncodable?.toDictionary() ?? [:]
        if !bodyParamaters.isEmpty {
            urlRequest.httpBody = encodeBody(bodyParamaters: bodyParamaters)
        }

        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = allHeaders
        return urlRequest
    }

    private func encodeBody(bodyParamaters: [String: Any]) -> Data? {
        return try? JSONSerialization.data(withJSONObject: bodyParamaters)
    }
}

private extension Dictionary {
    var queryString: String {
        return self.map { "\($0.key)=\($0.value)" }
            .joined(separator: "&")
            .addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) ?? ""
    }
}

private extension Encodable {
    func toDictionary() throws -> [String: Any]? {
        let data = try JSONEncoder().encode(self)
        let josnData = try JSONSerialization.jsonObject(with: data)
        return josnData as? [String: Any]
    }
}

public class JSONResponseDecoder: ResponseDecoder {
    private let jsonDecoder = JSONDecoder()
    public init() { }
    public func decode<T: Decodable>(_ data: Data) throws -> T {
        return try jsonDecoder.decode(T.self, from: data)
    }
}
