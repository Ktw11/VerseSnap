//
//  AuthRepositoryImpl.swift
//  Repository
//
//  Created by 공태웅 on 3/2/25.
//

import Foundation
import VSNetwork
import Domain

public actor AuthRepositoryImpl: AuthRepository {
    
    // MARK: Lifecycle
    
    public init(networkProvider: NetworkProvidable) {
        self.networkProvider = networkProvider
    }
    
    // MARK: Properties
    
    private let networkProvider: NetworkProvidable
    
    // MARK: Methods

    public func signIn(token: String, account: String) async throws -> SignInResponse {
        let api = AuthAPI.signIn(token: token, account: account)
        return try await networkProvider.request(api: api)
            .map(SignInResponse.self)
    }
    
    public func signIn(refreshToken: String) async throws -> SignInResponse {
        let api = AuthAPI.autoSignIn(refreshToken: refreshToken)
        return try await networkProvider.request(api: api)
            .map(SignInResponse.self)
    }
}
