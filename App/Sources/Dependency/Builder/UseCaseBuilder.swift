//
//  UseCaseBuilder.swift
//  App
//
//  Created by 공태웅 on 3/2/25.
//

import Foundation
import Domain

protocol UseCaseBuilder {
    var signInUseCase: SignInUseCase { get }
}

final class UseCaseComponent: UseCaseBuilder {
    
    // MARK: Lifecycle
    
    init(repositoryBuilder: RepositoryBuilder) {
        self.repositoryBuilder = repositoryBuilder
    }
    
    // MARK: Properties
    
    private let repositoryBuilder: RepositoryBuilder
    
    var signInUseCase: SignInUseCase {
        SignInUseCaseImpl(
            authRepository: repositoryBuilder.authRepository,
            signInInfoRepository: repositoryBuilder.signInInfoRepository
        )
    }
}
