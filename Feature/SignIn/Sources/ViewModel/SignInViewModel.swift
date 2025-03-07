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
    }
    
    // MARK: Properties
    
    let accounts: [ThirdPartyAccount]
    
    private var isLoading: Bool = false
    private let useCase: SignInUseCase
    
    // MARK: Methods
    
    func didTapSignInButton(account: ThirdPartyAccount) {
        guard !isLoading else { return }
        isLoading = true
        
        Task { [weak self, useCase] in
            defer { self?.isLoading = false }
            
            do {
                _ = try await useCase.signIn(account: account)
            } catch {
                #warning("에러 대응 필요")
            }
        }
    }
}
