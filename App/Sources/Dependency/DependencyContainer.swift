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

final class DependencyContainer {
    
    // MARK: LifeCycle

    @MainActor
    init() {
        Task {
            await networkProvider.setTokenStore(tokenStore)
            await networkProvider.setTokenRefresher(authUseCase)
        }
    }
    
    // MARK: Definitions
    
    private enum Constants {
        static let minimumImageLength: CGFloat = 512
    }
    
    // MARK: Properties

    var authUseCase: AuthUseCase & TokenRefreshable {
        AuthUseCaseImpl(
            authRepository: authRepository,
            signInInfoRepository: signInInfoRepository,
            thirdAuthProvider: thirdAuthProvider,
            tokenUpdator: tokenStore
        )
    }
    
    @MainActor
    let appStateStore: GlobalAppStateStore = .init()
    lazy var diaryEventPublisher: DiaryEventSender & DiaryEventReceiver = DiaryEventPublisher()
    lazy var thirdAuthProvider: ThirdPartyAuthProvidable = {
        ThirdPartyAuthProvider(accounts: [.apple, .kakao])
    }()
    lazy var tokenStore: TokenStorable & TokenUpdatable = TokenStore()
    lazy var localDataSouceContainer: LocalDataSourceContainer = {
        LocalDataSourceContainer(container: modelContainer)
    }()
    let networkProvider: NetworkProvidable = NetworkProvider(
        configuration: NetworkConfiguration(baseUrlString: AppKeys.baseUrl)
    )
    
    private let modelContainer: ModelContainer = {
        let schema = Schema([
            PermanentDiary.self,
            PermanentSignInInfo.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        return try! ModelContainer(for: schema, configurations: [modelConfiguration])
    }()
    
    private var authRepository: AuthRepository {
        AuthRepositoryImpl(networkProvider: networkProvider)
    }
    
    private var signInInfoRepository: SignInInfoRepository {
        SignInInfoRepositoryImpl(dataSource: localDataSouceContainer.signInInfoDataSource)
    }
    
    // MARK: Methods

    @ViewBuilder
    @MainActor
    func buildRootView() -> some View {
        let viewModel = RootViewModel(
            appStateStore: appStateStore,
            useCase: authUseCase
        )
        RootView(
            viewModel: viewModel,
            dependency: self
        )
    }

    @ViewBuilder
    @MainActor
    func buildRootTabView(user: User) -> some View {
        let container = UserSessionDependencyContainer(dependency: self)
        
        RootTabView()
            .environment(\.userSessionContainer, container)
    }
}
