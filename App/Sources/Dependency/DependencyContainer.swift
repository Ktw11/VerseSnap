//
//  DependencyContainer.swift
//  App
//
//  Created by 공태웅 on 2/22/25.
//

import SwiftUI
import Domain
import ThirdPartyAuth
import VSNetwork

final class DependencyContainer {
    
    // MARK: LifeCycle

    @MainActor
    init() {
        Task {
            await networkProvider.setTokenStore(tokenStore)
            await networkProvider.setTokenRefresher(useCaseBuilder.signInUseCase)
        }
    }
    
    // MARK: Properties
    
    lazy var thirdAuthProvider: ThirdPartyAuthProvidable = {
        ThirdPartyAuthProvider(accounts: [.apple, .kakao])
    }()
    lazy var repositoryBuilder: RepositoryBuilder = {
        RepositoryComponent(networkProvider: networkProvider)
    }()
    lazy var useCaseBuilder: UseCaseBuilder = {
        UseCaseComponent(
            repositoryBuilder: repositoryBuilder,
            thirdAuthProvider: thirdAuthProvider,
            tokenStore: tokenStore
        )
    }()
    
    @MainActor
    let appStateStore: GlobalAppStateStore = .init()
    let tokenStore: TokenStore = .init()
    
    private let networkProvider: NetworkProvidable = NetworkProvider(
        configuration: NetworkConfiguration(baseUrlString: AppKeys.baseUrl)
    )
    
    // MARK: Methods
    
    @ViewBuilder
    @MainActor
    func buildRootView() -> some View {
        let viewModel = RootViewModel(
            appStateStore: appStateStore,
            useCase: useCaseBuilder.signInUseCase
        )
        RootView(
            viewModel: viewModel,
            signInBuilder: signInBuilder,
            homeBuilder: homeBuilder,
            newVerseBuilder: newVerseBuilder
        )
    }
}
