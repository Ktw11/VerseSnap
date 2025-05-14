//
//  UserSessionDependencyContainer+Profile.swift
//  App
//
//  Created by 공태웅 on 5/11/25.
//

import Foundation
import Profile
import ProfileInterface

extension UserSessionDependencyContainer {
    @MainActor
    var profileBuilder: some ProfileBuilder {
        ProfileComponent(
            user: user,
            dependency: ProfileDependency(
                userUseCase: useCaseBuilder.userUseCase,
                signOutUseCase: useCaseBuilder.signOutUseCase(
                    authRepository: authDependencyContainer.authRepository,
                    signInInfoRepository: authDependencyContainer.signInInfoRepository
                ),
                appStateUpdator: appStateStore
            )
        )
    }
}
