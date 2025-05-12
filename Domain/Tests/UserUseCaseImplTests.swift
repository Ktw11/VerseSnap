//
//  UserUseCaseImplTests.swift
//  Domain
//
//  Created by 공태웅 on 5/11/25.
//

import XCTest
@testable import Domain

final class UserUseCaseImplTests: XCTestCase {
    var sut: UserUseCaseImpl!
    var repository: MockUserRepository!
    
    override func setUp() {
        super.setUp()
     
        repository = MockUserRepository()
        sut = UserUseCaseImpl(repository: repository)
    }
    
    override func tearDown() {
        repository = nil
        sut = nil
        
        super.tearDown()
    }
    
    
    func test_updateNickname_when_repository_fails_then_throw_error() async {
        // given
        let givenNickname: String = "nickname"
        repository.expectedUpdateNicknameError = TestError.common
        
        // when
        do {
            _ = try await sut.updateNickname(to: givenNickname)
            XCTFail()
        } catch {
            // then
            XCTAssertTrue(repository.isUpdateNicknameCalled)
            XCTAssertEqual(givenNickname, repository.requestedUpdateNickname)
        }
    }
    
    func test_updateNickname_when_repository_success_then_success() async {
        // given
        let givenNickname: String = "nickname"
        repository.expectedUpdateNicknameError = nil
        
        // when
        do {
            _ = try await sut.updateNickname(to: givenNickname)
            
            // then
            XCTAssertTrue(repository.isUpdateNicknameCalled)
            XCTAssertEqual(givenNickname, repository.requestedUpdateNickname)
        } catch {
            XCTFail()
        }
    }
}
