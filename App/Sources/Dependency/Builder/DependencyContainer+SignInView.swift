//
//  DependencyContainer+SignIn.swift
//  App
//
//  Created by 공태웅 on 2/23/25.
//

import SwiftUI
import SignIn
import SignInInterface

extension DependencyContainer {
    @MainActor
    var signInBuilder: some SignInBuilder {
        SignInComponent(
            dependency: SignInDependency(
                accounts: [.apple, .kakao],
                useCase: authUseCase,
                appStateUpdator: appStateStore
            )
        )
    }
}
