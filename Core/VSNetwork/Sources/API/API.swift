//
//  API.swift
//  Network
//
//  Created by 공태웅 on 3/2/25.
//

import Foundation

public protocol API: Sendable {
    var path: String { get }
    var method: HttpMethod { get }
    var contentType: ContentType { get }
    var headers: [String: String] { get }
    var queryParameters: [String: String]? { get }
    var bodyParameters: [String: Any]? { get }
    var needsAuthorization: Bool { get }
}

public extension API {
    var contentType: ContentType {
        .json
    }
    
    var headers: [String: String] {
        switch contentType {
        case .json:
            ["Content-Type": "application/json"]
        case .multipart(let multipartFormData):
            [:]
        }
    }
    
    var queryParameters: [String: String]? {
        nil
    }
    
    var bodyParameters: [String: Any]? {
        nil
    }

    var needsAuthorization: Bool {
        false
    }
}
