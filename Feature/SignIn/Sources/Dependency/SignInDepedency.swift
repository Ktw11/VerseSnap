//
//  SignInDepedency.swift
//  SignIn
//
//  Created by 공태웅 on 2/22/25.
//

import Foundation

public struct SignInDependency {
    let signInTypes: [SignInType]
    
    public init(signInTypes: [SignInType]) {
        self.signInTypes = signInTypes
    }
}
