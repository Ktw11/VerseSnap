//
//  SignInComponent.swift
//  SignIn
//
//  Created by 공태웅 on 2/23/25.
//

import SwiftUI
import SignInInterface

public final class SignInComponent: SignInBuilder {
    
    // MARK: Lifecycle
    public init(dependency: SignInDependency) {
        self.dependency = dependency
    }
    
    // MARK: Properties
    
    private let dependency: SignInDependency
    
    // MARK: Methods
    
    @MainActor
    @ViewBuilder
    public func build() -> SignInView {
        let viewModel = SignInViewModel(dependency: dependency)
        SignInView(viewModel: viewModel)
    }
}
