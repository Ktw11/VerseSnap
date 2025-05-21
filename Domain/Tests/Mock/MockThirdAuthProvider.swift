//
//  MockThirdAuthProvider.swift
//  Domain
//
//  Created by 공태웅 on 5/21/25.
//

import Foundation
@testable import Domain

final class MockThirdAuthProvider: ThirdPartyAuthProvidable, @unchecked Sendable {
    
    var isHandleURLCalled: Bool = false
    var expectedHandleURL: Bool?
    var isGetTokenCalled: Bool = false
    var expectedGetToken: String?
    var isDidSignInCalled: Bool = false
    var isSignOutCalled: Bool = false
    var isUnlinkCalled: Bool = false
    
    func handleURL(_ url: URL) -> Bool {
        isHandleURLCalled = true
        
        return expectedHandleURL!
    }
    
    func getToken(account: ThirdPartyAccount) async throws -> String {
        isGetTokenCalled = true
        return expectedGetToken!
    }
    
    func didSignIn(account: ThirdPartyAccount) async {
        isDidSignInCalled = true
    }
    
    func signOut() async throws {
        isSignOutCalled = true
    }
    
    func unlink() async throws {
        isUnlinkCalled = true
    }
}
