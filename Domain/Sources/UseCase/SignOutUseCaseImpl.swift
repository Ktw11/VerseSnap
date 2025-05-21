//
//  SignOutUseCaseImpl.swift
//  Domain
//
//  Created by 공태웅 on 5/12/25.
//

import Foundation

public actor SignOutUseCaseImpl: SignOutUseCase {
    
    // MARK: Lifecycle
    
    public init(
        authRepository: AuthRepository,
        signInInfoRepository: SignInInfoRepository,
        diaryRepository: DiaryRepository,
        thirdAuthProvider: ThirdPartyAuthProvidable,
        tokenUpdator: TokenUpdatable
    ) {
        self.authRepository = authRepository
        self.signInInfoRepository = signInInfoRepository
        self.diaryRepository = diaryRepository
        self.thirdAuthProvider = thirdAuthProvider
        self.tokenUpdator = tokenUpdator
    }
    
    // MARK: Properties
    
    private let authRepository: AuthRepository
    private let signInInfoRepository: SignInInfoRepository
    private let diaryRepository: DiaryRepository
    private let thirdAuthProvider: ThirdPartyAuthProvidable
    private let tokenUpdator: TokenUpdatable
    
    // MARK: Methdos
    
    public func signOut() async throws {
        try await authRepository.signOut()
        
        async let signOutThirdParty: Void = await thirdAuthProvider.signOut()
        async let resetUserSession: Void = await resetUserSession()
        _ = try? await (signOutThirdParty, resetUserSession)
    }
    
    public func deleteAccount() async throws {
        try await authRepository.deleteAccount()
        
        async let unlinkThirdParty: Void = await thirdAuthProvider.unlink()
        async let resetUserSession: Void = await resetUserSession()
        _ = try? await (unlinkThirdParty, resetUserSession)
    }
}

private extension SignOutUseCaseImpl {
    func resetUserSession() async {
        async let resetSignInInfo: Void = await signInInfoRepository.reset()
        async let deleteDiaries: Void = await diaryRepository.deleteAll()
        async let updateTokens: Void = await tokenUpdator.updateTokens(accessToken: nil, refreshToken: nil)
        
        _ = try? await (resetSignInInfo, deleteDiaries, updateTokens)
    }
}
