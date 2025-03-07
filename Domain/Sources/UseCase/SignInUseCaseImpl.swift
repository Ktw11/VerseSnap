//
//  SignInUseCaseImpl.swift
//  Domain
//
//  Created by 공태웅 on 3/2/25.
//

import Foundation

public actor SignInUseCaseImpl: SignInUseCase {
    
    // MARK: Lifecycle
    
    public init(
        authRepository: AuthRepository,
        signInInfoRepository: SignInInfoRepository,
        thirdAuthProvider: ThirdPartyAuthProvidable
    ) {
        self.authRepository = authRepository
        self.signInInfoRepository = signInInfoRepository
        self.thirdAuthProvider = thirdAuthProvider
    }
    
    // MARK: Properties
    
    private let authRepository: AuthRepository
    private let signInInfoRepository: SignInInfoRepository
    private let thirdAuthProvider: ThirdPartyAuthProvidable

    public func signInWithSavedToken() async -> SignInResponse? {
        guard let info = await signInInfoRepository.retrieve() else { return nil }
        guard let account = ThirdPartyAccount(rawValue: info.signInType) else { return nil }
        guard let response = try? await authRepository.signIn(refreshToken: info.refreshToken) else { return nil }
        updateSignInInfo(response, account: account)
        
        return response
    }
    
    public func signIn(account: ThirdPartyAccount) async throws -> SignInResponse {
        let token = try await thirdAuthProvider.getToken(account: account)
        let response = try await authRepository.signIn(token: token, account: account.rawValue)
        
        updateSignInInfo(response, account: account)
        return response
    }
}

private extension SignInUseCaseImpl {
    func updateSignInInfo(_ response: SignInResponse, account: ThirdPartyAccount) {
        Task.detached(priority: .medium) { [signInInfoRepository] in
            let refreshToken = response.user.refreshToken

            try? await signInInfoRepository.save(
                info: .init(refreshToken: refreshToken, signInType: account.rawValue)
            )
        }
    }
}
