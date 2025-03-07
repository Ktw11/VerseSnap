//
//  SignInUseCase.swift
//  Domain
//
//  Created by 공태웅 on 3/2/25.
//

import Foundation

public protocol SignInUseCase: Sendable {
    func signInWithSavedToken() async -> SignInResponse?
    func signIn(account: ThirdPartyAccount) async throws -> SignInResponse
}
