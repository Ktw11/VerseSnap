//
//  ProfileDependency.swift
//  Profile
//
//  Created by 공태웅 on 5/11/25.
//

import Foundation
import Domain

public struct ProfileDependency {
    
    // MARK: Lifecycle
    
    public init(
        userUseCase: UserUseCase,
        signOutUseCase: SignOutUseCase,
        appStateUpdator: GlobalAppStateUpdatable
    ) {
        self.userUseCase = userUseCase
        self.signOutUseCase = signOutUseCase
        self.appStateUpdator = appStateUpdator
    }
    
    // MARK: Properties

    let userUseCase: UserUseCase
    let signOutUseCase: SignOutUseCase
    let appStateUpdator: GlobalAppStateUpdatable
}
