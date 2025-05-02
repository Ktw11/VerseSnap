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
}

final class UseCaseComponent: UseCaseBuilder {
    
    // MARK: Lifecycle
    
    init(
        repositoryBuilder: RepositoryBuilder,
        thirdAuthProvider: ThirdPartyAuthProvidable,
        tokenStore: TokenUpdatable
    ) {
        self.repositoryBuilder = repositoryBuilder
        self.thirdAuthProvider = thirdAuthProvider
        self.tokenStore = tokenStore
    }
    
    // MARK: Properties
    
    private let repositoryBuilder: RepositoryBuilder
    private let thirdAuthProvider: ThirdPartyAuthProvidable
    private let tokenStore: TokenUpdatable
    
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
            imageUploader: ImageUploader(),
            repository: repositoryBuilder.verseRepository
        )
    }
}
