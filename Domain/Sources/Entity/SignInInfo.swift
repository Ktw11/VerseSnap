//
//  SignInInfo.swift
//  Entity
//
//  Created by 공태웅 on 3/2/25.
//

import Foundation

public struct SignInInfo: Sendable {
    public let refreshToken: String
    public let signInType: String
    public let userId: String
    
    public init(refreshToken: String, signInType: String, userId: String) {
        self.refreshToken = refreshToken
        self.signInType = signInType
        self.userId = userId
    }
}
