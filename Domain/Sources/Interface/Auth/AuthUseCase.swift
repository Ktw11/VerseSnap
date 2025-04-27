//
//  AuthUseCase.swift
//  Domain
//
//  Created by 공태웅 on 3/2/25.
//

import Foundation

public protocol AuthUseCase: Sendable {
    func signInWithSavedToken() async -> SignInResponse?
    func signIn(account: ThirdPartyAccount) async throws -> SignInResponse
}
