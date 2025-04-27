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
                _ = try await useCase.signIn(account: account)
                self?.appStateUpdator.setScene(to: .tabs)
            } catch {
                self?.appStateUpdator.addToast(info: .init(message: "에러가 발생했습니다. 다시 시도해주세요."))
            }
        }
    }
}
