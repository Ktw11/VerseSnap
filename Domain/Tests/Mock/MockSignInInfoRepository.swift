//
//  MockSignInInfoRepository.swift
//  Domain
//
//  Created by 공태웅 on 5/12/25.
//

import Foundation
@testable import Domain

final class MockSignInInfoRepository: SignInInfoRepository, @unchecked Sendable {
    
    var isRetrieveCalled: Bool = false
    var expectedRetrieve: SignInInfo?
    
    var isSaveCalled: Bool = false
    var expectedSaveError: Error?
    
    var isResetCalled: Bool = false
    var expectedResetError: Error?
    
    func retrieve() async -> SignInInfo? {
        isRetrieveCalled = true
        return expectedRetrieve
    }
    
    func save(info: SignInInfo) async throws {
        isSaveCalled = true
        
        if let expectedSaveError {
            throw expectedSaveError
        }
    }
    
    func reset() async throws {
        isResetCalled = true
        
        if let expectedResetError {
            throw expectedResetError
        }
    }
}
