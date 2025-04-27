//
//  SignInDepedency.swift
//  SignIn
//
//  Created by 공태웅 on 2/22/25.
//

import Foundation
import Domain

public struct SignInDependency {
    let accounts: [ThirdPartyAccount]
    let useCase: AuthUseCase
    let appStateUpdator: GlobalAppStateUpdatable
    
    public init(
        accounts: [ThirdPartyAccount],
        useCase: AuthUseCase,
        appStateUpdator: GlobalAppStateUpdatable
    ) {
        self.accounts = accounts
        self.useCase = useCase
        self.appStateUpdator = appStateUpdator
    }
}
