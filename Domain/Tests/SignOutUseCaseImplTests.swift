//
//  SignOutUseCaseImplTests.swift
//  Domain
//
//  Created by 공태웅 on 5/12/25.
//

import XCTest
@testable import Domain

final class SignOutUseCaseImplTests: XCTestCase {
    
    var sut: SignOutUseCaseImpl!
    var authRepository: MockAuthRepository!
    var signInInfoRepository: MockSignInInfoRepository!
    var diaryRepository: MockDiaryRepository!
    var tokenUpdator: MockTokenUpdator!
    
    override func setUp() {
        super.setUp()
        
        authRepository = MockAuthRepository()
        signInInfoRepository = MockSignInInfoRepository()
        diaryRepository = MockDiaryRepository()
        tokenUpdator = MockTokenUpdator()
        
        sut = SignOutUseCaseImpl(
            authRepository: authRepository,
            signInInfoRepository: signInInfoRepository,
            diaryRepository: diaryRepository,
            tokenUpdator: tokenUpdator
        )
    }
    
    override func tearDown() {
        tokenUpdator = nil
        diaryRepository = nil
        signInInfoRepository = nil
        authRepository = nil
        sut = nil
        
        super.tearDown()
    }
    
    func test_signOut_when_authRepository_fails_then_throw_error() async {
        // given
        authRepository.expectedSignOutError = TestError.common
        
        // when
        do {
            try await sut.signOut()
            XCTFail()
        } catch TestError.common {
            // then
            XCTAssertTrue(authRepository.isSignOutCalled)
            XCTAssertFalse(signInInfoRepository.isResetCalled)
            XCTAssertFalse(diaryRepository.isDeleteAllCalled)
            XCTAssertFalse(tokenUpdator.isUpdateTokensCalled)
        } catch {
            XCTFail()
        }
    }
    
    func test_signOut_when_authRepository_success_and_signInInfoRepository_fails_then_continue() async {
        // given
        signInInfoRepository.expectedResetError = TestError.common
        
        // when
        do {
            try await sut.signOut()
            
            // then
            XCTAssertTrue(authRepository.isSignOutCalled)
            XCTAssertTrue(signInInfoRepository.isResetCalled)
            XCTAssertTrue(diaryRepository.isDeleteAllCalled)
            XCTAssertTrue(tokenUpdator.isUpdateTokensCalled)
            XCTAssertEqual(tokenUpdator.requestedAccessToken, nil)
            XCTAssertEqual(tokenUpdator.requestedRefreshToken, nil)
        } catch {
            XCTFail()
        }
    }
    
    func test_signOut_when_authRepository_success_and_diaryRepository_fails_then_continue() async {
        // given
        diaryRepository.expectedDeleteAllError = TestError.common
        
        // when
        do {
            try await sut.signOut()
            
            // then
            XCTAssertTrue(authRepository.isSignOutCalled)
            XCTAssertTrue(signInInfoRepository.isResetCalled)
            XCTAssertTrue(diaryRepository.isDeleteAllCalled)
            XCTAssertTrue(tokenUpdator.isUpdateTokensCalled)
            XCTAssertEqual(tokenUpdator.requestedAccessToken, nil)
            XCTAssertEqual(tokenUpdator.requestedRefreshToken, nil)
        } catch {
            XCTFail()
        }
    }
    
    func test_signOut_success() async {
        // when
        do {
            try await sut.signOut()
            
            // then
            XCTAssertTrue(authRepository.isSignOutCalled)
            XCTAssertTrue(signInInfoRepository.isResetCalled)
            XCTAssertTrue(diaryRepository.isDeleteAllCalled)
            XCTAssertTrue(tokenUpdator.isUpdateTokensCalled)
            XCTAssertEqual(tokenUpdator.requestedAccessToken, nil)
            XCTAssertEqual(tokenUpdator.requestedRefreshToken, nil)
        } catch {
            XCTFail()
        }
    }
}
