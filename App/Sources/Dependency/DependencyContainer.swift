//
//  DependencyContainer.swift
//  App
//
//  Created by 공태웅 on 2/22/25.
//

import SwiftUI
import SwiftData
import Domain
import Repository
import ThirdPartyAuth
import VSNetwork

final class DependencyContainer: Sendable {
    
    // MARK: LifeCycle

    @MainActor
    init() {
        let schema = Schema([
            PermanentDiary.self,
            PermanentSignInInfo.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        let modelContainer = try! ModelContainer(for: schema, configurations: [modelConfiguration])
        
        self.localDataSouceContainer = LocalDataSourceContainer(container: modelContainer)
        self.authDependencyContainer = AuthDependencyContainer(
            networkProvider: networkProvider,
            signInInfoDataSource: localDataSouceContainer.signInInfoDataSource,
            thirdAuthProvider: thirdAuthProvider,
            tokenUpdator: tokenStore
        )
        
        Task {
            await networkProvider.setTokenStore(tokenStore)
            await networkProvider.setTokenRefresher(authDependencyContainer.authUseCase)
        }
    }
    
    // MARK: Definitions
    
    private enum Constants {
        static let minimumImageLength: CGFloat = 512
    }
    
    // MARK: Properties
    
    @MainActor
    let appStateStore: GlobalAppStateStore = .init()
    let diaryEventPublisher: DiaryEventSender & DiaryEventReceiver = DiaryEventPublisher()
    let thirdAuthProvider: ThirdPartyAuthProvidable = ThirdPartyAuthProvider(accounts: [.apple, .kakao])
    let tokenStore: TokenStorable & TokenUpdatable = TokenStore()
    let localDataSouceContainer: LocalDataSourceContainer
    let authDependencyContainer: AuthDependencyContainer
    let networkProvider: NetworkProvidable = NetworkProvider(
        configuration: NetworkConfiguration(baseUrlString: AppKeys.baseUrl)
    )
    
    // MARK: Methods

    @ViewBuilder
    @MainActor
    func buildRootView() -> some View {
        let viewModel = RootViewModel(
            appStateStore: appStateStore,
            useCase: authDependencyContainer.authUseCase
        )
        RootView(
            viewModel: viewModel,
            dependency: self
        )
    }

    @ViewBuilder
    @MainActor
    func buildRootTabView(user: User) -> some View {
        let container = UserSessionDependencyContainer(user: user, dependency: self)
        
        RootTabView()
            .environment(\.userSessionContainer, container)
    }
}
