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

protocol UseCaseBuilder {
    var authUseCase: AuthUseCase & TokenRefreshable{ get }
    var verseUseCase: VerseUseCase { get }
    var diaryUseCase: DiaryUseCase { get }
}

final class UseCaseComponent: UseCaseBuilder {
    
    // MARK: Lifecycle
    
    init(
        repositoryBuilder: RepositoryBuilder,
        thirdAuthProvider: ThirdPartyAuthProvidable,
        tokenStore: TokenUpdatable,
        minimumImageLength: CGFloat
    ) {
        self.repositoryBuilder = repositoryBuilder
        self.thirdAuthProvider = thirdAuthProvider
        self.tokenStore = tokenStore
        self.minimumImageLength = minimumImageLength
    }
    
    // MARK: Properties
    
    private let repositoryBuilder: RepositoryBuilder
    private let thirdAuthProvider: ThirdPartyAuthProvidable
    private let tokenStore: TokenUpdatable
    private let minimumImageLength: CGFloat
    
    var authUseCase: AuthUseCase & TokenRefreshable {
        AuthUseCaseImpl(
            authRepository: repositoryBuilder.authRepository,
            signInInfoRepository: repositoryBuilder.signInInfoRepository,
            thirdAuthProvider: thirdAuthProvider,
            tokenUpdator: tokenStore
        )
    }
    
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
            minImageLength: minimumImageLength
        )
    }
}
