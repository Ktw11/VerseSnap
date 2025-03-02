//
//  API+Extension.swift
//  Network
//
//  Created by 공태웅 on 3/2/25.
//

import Foundation

extension API {
    func makeURLRequest(baseURLString: String, accessToken: String?) throws -> URLRequest {
        guard var urlComponents = URLComponents(string: baseURLString) else {
            throw NetworkError.invalidURL
        }
        
        if let queryParameters {
            urlComponents.queryItems = queryParameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        
        guard let url = urlComponents.url?.appendingPathComponent(path) else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        if let bodyParameters {
            request.httpBody = try? JSONSerialization.data(withJSONObject: bodyParameters, options: [])
        }
        
        headers.forEach {
            request.setValue($1, forHTTPHeaderField: $0)
        }
        
        if let accessToken, needsAuthorization {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }

        return request
    }
}
