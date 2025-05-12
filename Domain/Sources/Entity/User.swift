//
//  User.swift
//  Domain
//
//  Created by 공태웅 on 3/2/25.
//

import Foundation

public struct User: Decodable, Sendable {
    
    // MARK: Lifecycle
    
    public init(
        id: String,
        nickname: String,
        loginType: String,
        refreshToken: String,
        createdAt: TimeInterval
    ) {
        self.id = id
        self.nickname = nickname
        self.loginType = loginType
        self.refreshToken = refreshToken
        self.createdAt = createdAt
    }
    
    // MARK: Properties
    
    public let id: String
    public let nickname: String
    public let loginType: String
    public let refreshToken: String
    public let createdAt: TimeInterval
}
