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
        useCase: UserUseCase,
        appStateUpdator: GlobalAppStateUpdatable
    ) {
        self.useCase = useCase
        self.appStateUpdator = appStateUpdator
    }
    
    // MARK: Properties

    let useCase: UserUseCase
    let appStateUpdator: GlobalAppStateUpdatable
}
