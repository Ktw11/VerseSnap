//
//  DependencyContainer+MockRootViewModel.swift
//  App
//
//  Created by 공태웅 on 3/8/25.
//

import Foundation
import SignIn

extension DependencyContainer {
    @MainActor
    var mockRootViewModel: RootViewModel {
        .init(appStateStore: GlobalAppStateStore(), useCase: MockSignInUseCase())
    }
}
