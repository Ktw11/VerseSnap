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
        tokenUpdator: TokenUpdatable
    ) {
        self.authRepository = authRepository
        self.signInInfoRepository = signInInfoRepository
        self.diaryRepository = diaryRepository
        self.tokenUpdator = tokenUpdator
    }
    
    // MARK: Properties
    
    private let authRepository: AuthRepository
    private let signInInfoRepository: SignInInfoRepository
    private let diaryRepository: DiaryRepository
    private let tokenUpdator: TokenUpdatable
    
    // MARK: Methdos
    
    public func signOut() async throws {
        try await authRepository.signOut()
        
        async let resetSignInInfo: Void = await signInInfoRepository.reset()
        async let deleteDiaries: Void = await diaryRepository.deleteAll()
        _ = try? await (resetSignInInfo, deleteDiaries)
        
        await tokenUpdator.updateTokens(accessToken: nil, refreshToken: nil)
    }
}
