//
//  SignInViewModel.swift
//  SignIn
//
//  Created by 공태웅 on 2/22/25.
//

import SwiftUI
import Domain

@Observable
@MainActor
public final class SignInViewModel {
    
    // MARK: Lifecycle

    public init(dependency: SignInDependency){
        self.signInTypes = dependency.signInTypes
        self.useCase = dependency.useCase
    }
    
    // MARK: Properties
    
    let signInTypes: [SignInType]
    
    private let useCase: SignInUseCase
}
