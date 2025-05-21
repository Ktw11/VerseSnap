//
//  ProfileViewModel.swift
//  Profile
//
//  Created by 공태웅 on 5/11/25.
//

import SwiftUI
import Domain
import Utils

@Observable
@MainActor
public final class ProfileViewModel: Sendable {
    
    // MARK: Lifecycle
    
    public init(
        nickname: String,
        userUseCase: UserUseCase,
        signOutUseCase: SignOutUseCase,
        appStateUpdator: GlobalAppStateUpdatable
    ) {
        self.nickname = nickname
        self.userUseCase = userUseCase
        self.signOutUseCase = signOutUseCase
        self.appStateUpdator = appStateUpdator
    }
    
    // MARK: Properties
    
    var attributedNickname: AttributedString {
        let left = AttributedString(nickname)
            .foreground(Color.white)
            .fonted(.suite(size: 20, weight: .bold))
        let right = AttributedString(localized: " 님")
            .foreground(Color.white)
            .fonted(.suite(size: 20, weight: .regular))
        
        return left + right
    }
    
    var editingNickname: String = ""
    var isNicknameFocused: Bool = false
    var isDeleteAccountModalPresented = false
    private(set) var isNicknameUpdating: Bool = false
    private(set) var isLoading: Bool = false
    
    private var nickname: String
    private let userUseCase: UserUseCase
    private let signOutUseCase: SignOutUseCase
    private let appStateUpdator: GlobalAppStateUpdatable
    
    // MARK: Methods
    
    func didTapNicknameChangeDone() {
        let newNickname: String = editingNickname
        guard newNickname.count > 0, newNickname.count < 9 else { return }
        
        isNicknameUpdating = true
        
        Task { [userUseCase, weak self] in
            defer {
                self?.isNicknameUpdating = false
                self?.isNicknameFocused = false
            }
            
            do {
                try await userUseCase.updateNickname(to: newNickname)
                self?.nickname = newNickname
            } catch {
                self?.appStateUpdator.addToast(info: .init(message: "에러가 발생했습니다. 다시 시도해주세요."))
            }
        }
    }
    
    func didTapSignOut() {
        executeSignOutUseCase { [signOutUseCase] in
            try await signOutUseCase.signOut()
        }
    }
    
    func didTapDeleteAccount() {
        isDeleteAccountModalPresented = true
    }
    
    func confirmDeleteAccount() {
        executeSignOutUseCase { [signOutUseCase] in
            try await signOutUseCase.deleteAccount()
        }
    }
}

private extension ProfileViewModel {
    func executeSignOutUseCase(_ execute: @escaping () async throws -> Void) {
        appStateUpdator.showLoadingOverlay(true)
        
        Task { [weak self] in
            defer { self?.appStateUpdator.showLoadingOverlay(false) }
            
            do {
                try await execute()
                self?.appStateUpdator.setScene(to: .signIn)
            } catch {
                self?.appStateUpdator.addToast(info: .init(message: "에러가 발생했습니다. 다시 시도해주세요."))
            }
        }
    }
}
