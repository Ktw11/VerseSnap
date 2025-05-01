//
//  AuthUseCasePreview.swift
//  PreviewSupport
//
//  Created by 공태웅 on 5/1/25.
//

import Foundation
import Domain

public final class AuthUseCasePreview: AuthUseCase, @unchecked Sendable {
    
    // MARK: Properties
    
    public var expectedSignInWithSavedToken: SignInResponse?
    public var expectedSignIn: SignInResponse?
    
    // MARK: Methods
    
    public func signInWithSavedToken() async -> SignInResponse? {
        expectedSignInWithSavedToken
    }
    
    public func signIn(account: Domain.ThirdPartyAccount) async throws -> SignInResponse {
        if let expectedSignIn {
            return expectedSignIn
        }
        
        throw PreviewError.notImplemented
    }
}

public extension AuthUseCasePreview {
    static var preview: AuthUseCasePreview {
        AuthUseCasePreview()
    }
}
