//
//  AuthRepository.swift
//  Domain
//
//  Created by 공태웅 on 3/2/25.
//

import Foundation

public protocol AuthRepository: Sendable {
    func signIn(token: String, account: String) async throws -> SignInResponse
    func signIn(refreshToken: String) async throws -> SignInResponse
    func refreshTokens(refreshToken: String) async throws -> AuthTokens
}
