//
//  MockTokenUpdator.swift
//  Domain
//
//  Created by 공태웅 on 5/12/25.
//

import Foundation
@testable import Domain

final class MockTokenUpdator: TokenUpdatable, @unchecked Sendable {
    
    var isUpdateTokensCalled: Bool = false
    var requestedAccessToken: String?
    var requestedRefreshToken: String?
    
    func updateTokens(accessToken: String?, refreshToken: String?) async {
        isUpdateTokensCalled = true
        
        requestedAccessToken = accessToken
        requestedRefreshToken = refreshToken
    }
}
