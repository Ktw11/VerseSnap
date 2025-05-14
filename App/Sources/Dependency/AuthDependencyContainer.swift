//
//  AuthDependencyContainer.swift
//  App
//
//  Created by 공태웅 on 5/14/25.
//

import Foundation
import VSNetwork
import Repository
import Domain

struct AuthDependencyContainer {
    
    // MARK: Lifecycle
    
    init(
        networkProvider: NetworkProvidable,
        signInInfoDataSource: SignInInfoDataSource,
        thirdAuthProvider: ThirdPartyAuthProvidable,
        tokenUpdator: TokenUpdatable
    ) {
        self.networkProvider = networkProvider
        self.signInInfoDataSource = signInInfoDataSource
        self.thirdAuthProvider = thirdAuthProvider
        self.tokenUpdator = tokenUpdator
    }
    
    var authUseCase: AuthUseCase & TokenRefreshable {
        AuthUseCaseImpl(
            authRepository: authRepository,
            signInInfoRepository: signInInfoRepository,
            thirdAuthProvider: thirdAuthProvider,
            tokenUpdator: tokenUpdator
        )
    }
    
    var authRepository: AuthRepository {
        AuthRepositoryImpl(networkProvider: networkProvider)
    }
    
    var signInInfoRepository: SignInInfoRepository {
        SignInInfoRepositoryImpl(dataSource: signInInfoDataSource)
    }
    
    private let networkProvider: NetworkProvidable
    private let signInInfoDataSource: SignInInfoDataSource
    private let thirdAuthProvider: ThirdPartyAuthProvidable
    private let tokenUpdator: TokenUpdatable
}
