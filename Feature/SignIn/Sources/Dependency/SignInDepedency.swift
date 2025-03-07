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
    let useCase: SignInUseCase
    
    public init(
        accounts: [ThirdPartyAccount],
        useCase: SignInUseCase
    ) {
        self.accounts = accounts
        self.useCase = useCase
    }
}
