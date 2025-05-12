//
//  MockUserRepository.swift
//  Domain
//
//  Created by 공태웅 on 5/11/25.
//

import Foundation
@testable import Domain

final class MockUserRepository: UserRepository, @unchecked Sendable {
    
    var isUpdateNicknameCalled = false
    var requestedUpdateNickname: String?
    var expectedUpdateNicknameError: Error?
    
    func updateNickname(to nickname: String) async throws {
        isUpdateNicknameCalled = true
        requestedUpdateNickname = nickname
        
        if let expectedUpdateNicknameError {
            throw expectedUpdateNicknameError
        }
    }
}
