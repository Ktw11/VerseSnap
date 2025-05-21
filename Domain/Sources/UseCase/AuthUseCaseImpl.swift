//
//  AuthUseCaseImpl.swift
//  Domain
//
//  Created by 공태웅 on 3/2/25.
//

import Foundation

public actor AuthUseCaseImpl: AuthUseCase {
    
    // MARK: Lifecycle
    
    public init(
        authRepository: AuthRepository,
        signInInfoRepository: SignInInfoRepository,
        thirdAuthProvider: ThirdPartyAuthProvidable,
        tokenUpdator: TokenUpdatable
    ) {
        self.authRepository = authRepository
        self.signInInfoRepository = signInInfoRepository
        self.thirdAuthProvider = thirdAuthProvider
        self.tokenUpdator = tokenUpdator
    }
    
    // MARK: Properties
    
    private let authRepository: AuthRepository
    private let signInInfoRepository: SignInInfoRepository
    private let thirdAuthProvider: ThirdPartyAuthProvidable
    private let tokenUpdator: TokenUpdatable

    public func signInWithSavedToken() async -> SignInResponse? {
        guard let info = await signInInfoRepository.retrieve() else { return nil }
        guard let account = ThirdPartyAccount(rawValue: info.signInType) else { return nil }
        guard let response = try? await authRepository.signIn(refreshToken: info.refreshToken) else { return nil }
        
        updateSignInInfo(user: response.user, account: account)
        
        let accessToken: String = response.accessToken
        let refreshToken: String = response.user.refreshToken
        await tokenUpdator.updateTokens(accessToken: accessToken, refreshToken: refreshToken)
        
        return response
    }
    
    public func signIn(account: ThirdPartyAccount) async throws -> SignInResponse {
        let token = try await thirdAuthProvider.getToken(account: account)
        let response = try await authRepository.signIn(token: token, account: account.rawValue)
        
        updateSignInInfo(user: response.user, account: account)
        
        let accessToken: String = response.accessToken
        let refreshToken: String = response.user.refreshToken
        await tokenUpdator.updateTokens(accessToken: accessToken, refreshToken: refreshToken)
        
        return response
    }
    
    public func refreshTokens() async throws {
        guard let info = await signInInfoRepository.retrieve() else { throw DomainError.cancelled }
        
        let tokens = try await authRepository.refreshTokens(refreshToken: info.refreshToken)
        await tokenUpdator.updateTokens(
            accessToken: tokens.accessToken,
            refreshToken: tokens.refreshToken
        )
        
        if let account = ThirdPartyAccount(rawValue: info.signInType) {
            updateSignInInfo(id: info.userId, refreshToken: tokens.refreshToken, account: account)
        }
    }
}

private extension AuthUseCaseImpl {
    func updateSignInInfo(user: User, account: ThirdPartyAccount) {
        updateSignInInfo(id: user.id, refreshToken: user.refreshToken, account: account)
    }
    
    func updateSignInInfo(id: String, refreshToken: String, account: ThirdPartyAccount) {
        Task.detached(priority: .medium) { [signInInfoRepository, thirdAuthProvider] in
            async let saveInfos: Void = await signInInfoRepository.save(
                info: .init(refreshToken: refreshToken, signInType: account.rawValue, userId: id)
            )
            async let didSignInAccount: Void = await thirdAuthProvider.didSignIn(account: account)
            
            _ = try? await (saveInfos, didSignInAccount)
        }
    }
}
