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
        
        try Task.checkCancellation()
        
        do {
            let data = try await networkProvider.request(api: api)
            return try JSONDecoder().decode(SignInResponse.self, from: data)
        } catch let error as DecodingError {
            throw DomainError.decodingFailed(error)
        } catch {
            throw DomainError.unknown
        }
    }
    
    public func signIn(refreshToken: String) async throws -> SignInResponse {
        let api = AuthAPI.autoSignIn(refreshToken: refreshToken)
        
        try Task.checkCancellation()
        
        do {
            let data = try await networkProvider.request(api: api)
            return try JSONDecoder().decode(SignInResponse.self, from: data)
        } catch let error as DecodingError {
            throw DomainError.decodingFailed(error)
        } catch {
            throw DomainError.unknown
        }
    }
    
    public func signOut() async throws {
        let api = AuthAPI.signOut
        
        try Task.checkCancellation()
        
        do {
            _ = try await networkProvider.request(api: api)
        } catch {
            throw DomainError.unknown
        }
    }
    
    public func deleteAccount() async throws {
        let api = AuthAPI.deleteAccount
        
        try Task.checkCancellation()
        
        do {
            _ = try await networkProvider.request(api: api)
        } catch {
            throw DomainError.unknown
        }
    }
    
    public func refreshTokens(refreshToken: String) async throws -> AuthTokens {
        let api = AuthAPI.refreshTokens(refreshToken: refreshToken)
        
        try Task.checkCancellation()
        
        do {
            let data = try await networkProvider.request(api: api)
            return try JSONDecoder().decode(AuthTokens.self, from: data)
        } catch let error as DecodingError {
            throw DomainError.decodingFailed(error)
        } catch {
            throw DomainError.unknown
        }
    }
}
