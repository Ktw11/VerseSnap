//
//  SignInViewModel.swift
//  SignIn
//
//  Created by 공태웅 on 2/22/25.
//

import SwiftUI

@Observable
@MainActor
public final class SignInViewModel {
    
    // MARK: Lifecycle

    public init(dependency: SignInDependency){
        self.signInTypes = dependency.signInTypes
    }
    
    // MARK: Properties
    
    let signInTypes: [SignInType]
}
