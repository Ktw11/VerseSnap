//
//  SignInDepedency.swift
//  SignIn
//
//  Created by 공태웅 on 2/22/25.
//

import Foundation
import Domain
import ThirdPartyAuth

public struct SignInDependency {
    let signInTypes: [SignInType]
    let useCase: SignInUseCase
    let authProvider: ThirdPartyAuthProvidable
    
    public init(
        signInTypes: [SignInType],
        useCase: SignInUseCase,
        authProvider: ThirdPartyAuthProvidable
    ) {
        self.signInTypes = signInTypes
        self.useCase = useCase
        self.authProvider = authProvider
    }
}
