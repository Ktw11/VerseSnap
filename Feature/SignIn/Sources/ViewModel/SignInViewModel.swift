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
        self.accounts = dependency.accounts
        self.useCase = dependency.useCase
        self.appStateUpdator = dependency.appStateUpdator
    }
    
    // MARK: Properties
    
    let accounts: [ThirdPartyAccount]
    var showProgressView: Bool { isLoading }
    
    private let useCase: AuthUseCase
    private let appStateUpdator: GlobalAppStateUpdatable
    private var isLoading: Bool = false
    
    // MARK: Methods
    
    func didTapSignInButton(account: ThirdPartyAccount) {
        guard !isLoading else { return }
        isLoading = true
        
        Task { [weak self, useCase] in
            defer { self?.isLoading = false }
            
            do {
                let result = try await useCase.signIn(account: account)
                self?.appStateUpdator.setScene(to: .tabs(result.user))
            } catch {
                let message = String(localized: "An error occurred. Please try again later.", bundle: .module)
                self?.appStateUpdator.addToast(info: .init(message: message))
            }
        }
    }
}
