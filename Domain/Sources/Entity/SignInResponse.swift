//
//  SignInResponse.swift
//  Domain
//
//  Created by 공태웅 on 3/2/25.
//

import Foundation

public struct SignInResponse: Decodable, Sendable {
    public let user: User
    public let accessToken: String
    
    public init(user: User, accessToken: String) {
        self.user = user
        self.accessToken = accessToken
    }
}
