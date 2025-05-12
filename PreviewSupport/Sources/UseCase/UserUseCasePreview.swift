//
//  UserUseCasePreview.swift
//  PreviewSupport
//
//  Created by 공태웅 on 5/12/25.
//

import Foundation
import Domain

public final class UserUseCasePreview: UserUseCase, @unchecked Sendable {
    
    var expectedUpdateNicknameError: Error?
    
    public func updateNickname(to nickname: String) async throws {
        if let expectedUpdateNicknameError {
            throw expectedUpdateNicknameError
        }
    }
}

public extension UserUseCasePreview {
    static var preview: UserUseCasePreview {
        UserUseCasePreview()
    }
}
