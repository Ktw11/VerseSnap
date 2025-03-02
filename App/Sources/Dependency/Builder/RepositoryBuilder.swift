//
//  RepositoryBuilder.swift
//  App
//
//  Created by 공태웅 on 3/2/25.
//

import Foundation
import Domain
import Repository
import Network

protocol RepositoryBuilder {
    var authRepository: AuthRepository { get }
    var signInInfoRepository: SignInInfoRepository { get }
}

final class RepositoryComponent: RepositoryBuilder {

    // MARK: Lifecycle
    
    init(networkProvider: NetworkProvidable) {
        self.networkProvider = networkProvider
    }
    
    // MARK: Properties
    
    private let networkProvider: NetworkProvidable
    private lazy var signInInfoDataSource: SignInInfoDataSource = {
        SignInInfoLocalDataSource()
    }()
    
    var authRepository: AuthRepository {
        AuthRepositoryImpl(networkProvider: networkProvider)
    }
    
    var signInInfoRepository: SignInInfoRepository {
        SignInInfoRepositoryImpl(dataSource: signInInfoDataSource)
    }
}
