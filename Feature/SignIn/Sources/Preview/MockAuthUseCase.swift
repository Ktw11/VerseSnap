//
//  MockAuthUseCase.swift
//  SignIn
//
//  Created by 공태웅 on 3/2/25.
//

import Foundation
import Domain

public final class MockAuthUseCase: AuthUseCase, @unchecked Sendable {
    
    public init() { }
    
    static var preview: MockAuthUseCase {
        MockAuthUseCase()
    }
    
    public var expectedSignInWithSavedToken: SignInResponse?
    public var expectedSignIn: SignInResponse?
    
    public func signInWithSavedToken() async -> SignInResponse? {
        expectedSignInWithSavedToken
    }
    
    public func signIn(account: ThirdPartyAccount) async throws -> SignInResponse {
        if let expectedSignIn {
            return expectedSignIn
        }
        
        throw NSError()
    }
}
