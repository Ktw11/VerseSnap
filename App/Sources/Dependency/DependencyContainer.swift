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
    init() { }
    
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
            thirdAuthProvider: thirdAuthProvider
        )
    }()
    
    @MainActor
    let appStateStore: GlobalAppStateStore = .init()
    
    private let networkProvider: NetworkProvidable = NetworkProvider(
        configuration: NetworkConfiguration(baseUrlString: AppKeys.baseUrl)
    )
    
    // MARK: Methods
    
    @ViewBuilder
    @MainActor
    func buildRootView() -> some View {
        let viewModel = RootViewModel(useCase: useCaseBuilder.signInUseCase)
        RootView(
            viewModel: viewModel,
            signInBuilder: signInBuilder,
            homeBuilder: homeBuilder,
            newDiaryBuilder: newDiaryBuilder
        )
    }
}
