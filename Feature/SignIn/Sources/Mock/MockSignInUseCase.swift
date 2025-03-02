//
//  MockSignInViewModel.swift
//  SignIn
//
//  Created by 공태웅 on 3/2/25.
//

import Foundation
import Domain

class MockSignInUseCase: SignInUseCase, @unchecked Sendable {
    
    static var preview: MockSignInUseCase {
        MockSignInUseCase()
    }
    
    var expectedSignInWithSavedToken: SignInResponse?
    var expectedSignIn: SignInResponse?
    
    func signInWithSavedToken() async -> SignInResponse? {
        expectedSignInWithSavedToken
    }
    
    func signIn(token: String, account: String) async throws -> SignInResponse {
        if let expectedSignIn {
            return expectedSignIn
        }
        
        throw NSError()
    }
}
