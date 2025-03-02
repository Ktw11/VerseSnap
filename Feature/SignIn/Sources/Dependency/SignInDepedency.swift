//
//  SignInDepedency.swift
//  SignIn
//
//  Created by 공태웅 on 2/22/25.
//

import Foundation
import Domain

public struct SignInDependency {
    let signInTypes: [SignInType]
    let useCase: SignInUseCase
    
    public init(signInTypes: [SignInType]) {
        self.signInTypes = signInTypes
    }
}
