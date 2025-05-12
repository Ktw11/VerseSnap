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
        useCase: UserUseCase,
        appStateUpdator: GlobalAppStateUpdatable
    ) {
        self.nickname = nickname
        self.useCase = useCase
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
    private(set) var isNicknameUpdating: Bool = false
    
    private var nickname: String
    private let useCase: UserUseCase
    private let appStateUpdator: GlobalAppStateUpdatable
    
    // MARK: Methods
    
    func didTapNicknameChangeDone() {
        let newNickname: String = editingNickname
        guard newNickname.count > 0, newNickname.count < 9 else { return }
        
        isNicknameUpdating = true
        
        Task { [useCase, weak self] in
            defer {
                self?.isNicknameUpdating = false
                self?.isNicknameFocused = false
            }
            
            do {
                try await useCase.updateNickname(to: newNickname)
                self?.nickname = newNickname
            } catch {
                self?.appStateUpdator.addToast(info: .init(message: "에러가 발생했습니다. 다시 시도해주세요."))
            }
        }
    }
}
