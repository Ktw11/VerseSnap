//
//  MockSignInViewModel.swift
//  SignIn
//
//  Created by 공태웅 on 3/2/25.
//

import Foundation
import Domain

public final class MockSignInUseCase: SignInUseCase, @unchecked Sendable {
    
    public init() { }
    
    static var preview: MockSignInUseCase {
        MockSignInUseCase()
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
