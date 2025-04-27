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
    
    init(appStateStore: GlobalAppStateStore, useCase: SignInUseCase) {
        self.appStateStore = appStateStore
        self.useCase = useCase
    }
    
    // MARK: Properties
    
    var scene: AppScene {
        appStateStore.scene
    }
    private let appStateStore: GlobalAppStateStore
    private let useCase: SignInUseCase
    
    // MARK: Methods
    
    func trySignIn() {
        Task { [weak self, useCase] in
            if let _ = await useCase.signInWithSavedToken() {
                self?.appStateStore.setScene(to: .tabs)
            } else {
                self?.appStateStore.setScene(to: .signIn)
            }
        }
    }
    
    func setScene(to scene: AppScene) {
        appStateStore.setScene(to: scene)
    }
}
