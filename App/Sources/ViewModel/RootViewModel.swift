//
//  RootViewModel.swift
//  App
//
//  Created by 공태웅 on 2/22/25.
//

import SwiftUI
import Domain

@Observable
@MainActor
final class RootViewModel {
    
    // MARK: Lifecycle
    
    init(useCase: SignInUseCase) {
        self.useCase = useCase
    }
    
    // MARK: Properties
    
    var scene: AppScene = .splash
    private let useCase: SignInUseCase
    
    // MARK: Methods
    
    func trySignIn() {
        Task { [weak self, useCase] in
            if let result = await useCase.signInWithSavedToken() {
                self?.scene = .tabs
            } else {
                self?.scene = .signIn
            }
        }
    }
    
    func setScene(to scene: AppScene) {
        self.scene = scene
    }
}
