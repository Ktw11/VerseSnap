//
//  MockAuthRepository.swift
//  Domain
//
//  Created by 공태웅 on 5/12/25.
//

import Foundation
@testable import Domain

final class MockAuthRepository: AuthRepository, @unchecked Sendable {
    
    var isSignInWithTokenCalled: Bool = false
    var expectedSignInWithToken: SignInResponse?
    var expectedSignInWithTokenError: Error?
    
    var isSignInWithRefreshTokenCalled: Bool = false
    var expectedSignInWithRefreshToken: SignInResponse?
    var expectedSignInWithRefreshTokenError: Error?
    
    var isSignOutCalled: Bool = false
    var expectedSignOutError: Error?
    
    var isRefreshTokensCalled: Bool = false
    var expectedRefreshToken: AuthTokens?
    var expectedRefreshTokenError: Error?
    
    func signIn(token: String, account: String) async throws -> SignInResponse {
        isSignInWithTokenCalled = true
        
        if let expectedSignInWithToken {
            return expectedSignInWithToken
        } else if let expectedSignInWithTokenError {
            throw expectedSignInWithTokenError
        } else {
            throw TestError.notImplemented
        }
    }
    
    func signIn(refreshToken: String) async throws -> SignInResponse {
        isSignInWithRefreshTokenCalled = true
        
        if let expectedSignInWithRefreshToken {
            return expectedSignInWithRefreshToken
        } else if let expectedSignInWithRefreshTokenError {
            throw expectedSignInWithRefreshTokenError
        } else {
            throw TestError.notImplemented
        }
    }
    
    func signOut() async throws {
        isSignOutCalled = true
        
        if let expectedSignOutError {
            throw expectedSignOutError
        }
    }
    
    func refreshTokens(refreshToken: String) async throws -> AuthTokens {
        isRefreshTokensCalled = true
        
        if let expectedRefreshToken {
            return expectedRefreshToken
        } else if let expectedRefreshTokenError {
            throw expectedRefreshTokenError
        } else {
            throw TestError.notImplemented
        }
    }
}
