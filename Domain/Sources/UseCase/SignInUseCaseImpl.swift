//
//  SignInUseCaseImpl.swift
//  Domain
//
//  Created by 공태웅 on 3/2/25.
//

import Foundation

public actor SignInUseCaseImpl {
    
    // MARK: Lifecycle
    
    public init(
        authRepository: AuthRepository,
        signInInfoRepository: SignInInfoRepository
    ) {
        self.authRepository = authRepository
        self.signInInfoRepository = signInInfoRepository
    }
    
    // MARK: Properties
    
    private let authRepository: AuthRepository
    private let signInInfoRepository: SignInInfoRepository

    public func signInWithSavedToken() async -> SignInResponse? {
        guard let info = await signInInfoRepository.retrieve() else { return nil }
        guard let response = try? await authRepository.signIn(refreshToken: info.refreshToken) else { return nil }
        updateSignInInfo(response, account: info.signInType)
        
        return response
    }
    
    public func signIn(token: String, account: String) async throws -> SignInResponse {
        let response = try await authRepository.signIn(token: token, account: account)
        
        updateSignInInfo(response, account: account)
        return response
    }
}

private extension SignInUseCaseImpl {
    func updateSignInInfo(_ response: SignInResponse, account: String) {
        Task.detached(priority: .medium) { [signInInfoRepository] in
            let refreshToken = response.user.refreshToken

            try? await signInInfoRepository.save(
                info: .init(refreshToken: refreshToken, signInType: account)
            )
        }
    }
}
