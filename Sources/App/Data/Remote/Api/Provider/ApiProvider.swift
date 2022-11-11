//
//  ApiProvider.swift
//  ImageApp
//
//  Created by Adonys Rauda on 11/11/22.
//

import Foundation

struct ApiProvider {
    
    private let config: NetworkConfigurable

    init(config: NetworkConfigurable = ApiConfiguration.config) {
        self.config = config
    }
    
    func request<T: Decodable, E: ResponseRequestable>(endpoint: E) async throws -> T where E.Response == T {
        var request = try endpoint.urlRequest(networkConfig: config)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        #if DEBUG
            print("RESPONSE: \(response.debugDescription)")
            if let jsonResponse = String(data: data, encoding: .utf8) {
                print("**********************************")
                print("Response JSON : \(jsonResponse)")
                print("**********************************")
            }
        #endif

        let result: T = try endpoint.responseDecoder.decode(data)
        return result

    }

}
