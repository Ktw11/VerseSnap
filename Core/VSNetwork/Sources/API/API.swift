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
    var headers: [String: String] { get }
    var queryParameters: [String: String]? { get }
    var bodyParameters: [String: Any]? { get }
    var needsAuthorization: Bool { get }
}

public extension API {
    var headers: [String: String] {
        ["Content-Type": "application/json"]
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
