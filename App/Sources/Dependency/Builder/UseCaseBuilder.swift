//
//  UseCaseBuilder.swift
//  App
//
//  Created by 공태웅 on 3/2/25.
//

import Foundation
import Domain
import VSNetwork
import RemoteStorage

protocol UseCaseBuilder: Sendable {
    var verseUseCase: VerseUseCase { get }
    var diaryUseCase: DiaryUseCase { get }
    var userUseCase: UserUseCase { get }
    
    func signOutUseCase(authRepository: AuthRepository, signInInfoRepository: SignInInfoRepository) -> SignOutUseCase
}

final class UseCaseComponent: UseCaseBuilder {
    
    // MARK: Lifecycle
    
    init(
        repositoryBuilder: RepositoryBuilder,
        thirdAuthProvider: ThirdPartyAuthProvidable,
        tokenStore: TokenUpdatable,
        diaryEventSender: DiaryEventSender,
        minimumImageLength: CGFloat
    ) {
        self.repositoryBuilder = repositoryBuilder
        self.thirdAuthProvider = thirdAuthProvider
        self.tokenStore = tokenStore
        self.diaryEventSender = diaryEventSender
        self.minimumImageLength = minimumImageLength
    }
    
    // MARK: Properties
    
    private let repositoryBuilder: RepositoryBuilder
    private let thirdAuthProvider: ThirdPartyAuthProvidable
    private let tokenStore: TokenUpdatable
    private let diaryEventSender: DiaryEventSender
    private let minimumImageLength: CGFloat

    var verseUseCase: VerseUseCase {
        VerseUseCaseImpl(
            locale: Locale.current,
            imageConverter: ImageConverter(),
            repository: repositoryBuilder.verseRepository,
            minImageLength: minimumImageLength
        )
    }
    
    var diaryUseCase: DiaryUseCase {
        DiaryUseCaseImpl(
            imageConverter: ImageConverter(),
            imageUploader: ImageUploader(),
            repository: repositoryBuilder.diaryRepository,
            diaryEventSender: diaryEventSender,
            minImageLength: minimumImageLength,
            calendar: Calendar(identifier: .gregorian)
        )
    }
    
    var userUseCase: UserUseCase {
        UserUseCaseImpl(repository: repositoryBuilder.userRepository)
    }
    
    func signOutUseCase(authRepository: AuthRepository, signInInfoRepository: SignInInfoRepository) -> SignOutUseCase {
        SignOutUseCaseImpl(
            authRepository: authRepository,
            signInInfoRepository: signInInfoRepository,
            diaryRepository: repositoryBuilder.diaryRepository,
            thirdAuthProvider: thirdAuthProvider,
            tokenUpdator: tokenStore
        )
    }
}
