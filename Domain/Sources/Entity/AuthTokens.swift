//
//  RefreshTokensResponse.swift
//  Domain
//
//  Created by 공태웅 on 4/27/25.
//

import Foundation

public struct AuthTokens: Decodable, Sendable {
    public init(accessToken: String, refreshToken: String) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
    
    public let accessToken: String
    public let refreshToken: String
}
