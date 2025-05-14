//
//  ProfileComponent.swift
//  Profile
//
//  Created by 공태웅 on 5/11/25.
//

import SwiftUI
import ProfileInterface
import Domain

public final class ProfileComponent: ProfileBuilder {
    
    // MARK: Lifecycle
    
    public init(user: User, dependency: ProfileDependency) {
        self.user = user
        self.dependency = dependency
    }
    
    // MARK: Properties
    
    private let user: User
    private let dependency: ProfileDependency
    
    @MainActor
    @ViewBuilder
    public func build() -> some View {
        let viewModel = ProfileViewModel(
            nickname: user.nickname,
            userUseCase: dependency.userUseCase,
            signOutUseCase: dependency.signOutUseCase,
            appStateUpdator: dependency.appStateUpdator
        )
        ProfileView(viewModel: viewModel)
    }
}
