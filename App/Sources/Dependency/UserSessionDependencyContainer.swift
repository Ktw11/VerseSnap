//
//  UserSessionDependencyContainer.swift
//  App
//
//  Created by 공태웅 on 5/10/25.
//

import Foundation
import VSNetwork
import Domain

final class UserSessionDependencyContainer: Sendable {
    
    // MARK: Lifecycle
    
    init(user: User, dependency: DependencyContainer) {
        let repositoryBuilder = RepositoryComponent(
            userId: user.id,
            networkProvider: dependency.networkProvider,
            localDataSouceContainer: dependency.localDataSouceContainer
        )
        let diaryEventPublisher = dependency.diaryEventPublisher
        
        self.user = user
        self.appStateStore = dependency.appStateStore
        self.useCaseBuilder = UseCaseComponent(
            repositoryBuilder: repositoryBuilder,
            thirdAuthProvider: dependency.thirdAuthProvider,
            tokenStore: dependency.tokenStore,
            diaryEventSender: diaryEventPublisher,
            minimumImageLength: Constants.minimumImageLength
        )
        self.diaryEventReceiver = diaryEventPublisher
    }
    
    // MARK: Definitions
    
    private enum Constants {
        static let minimumImageLength: CGFloat = 512
    }
    
    // MARK: Properties
    
    let user: User
    @MainActor let appStateStore: GlobalAppStateStore
    let useCaseBuilder: UseCaseBuilder
    let diaryEventReceiver: DiaryEventReceiver
}
