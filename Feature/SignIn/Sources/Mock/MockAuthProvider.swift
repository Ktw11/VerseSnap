//
//  MockAuthProvider.swift
//  SignIn
//
//  Created by 공태웅 on 3/2/25.
//

import Foundation
import ThirdPartyAuth

class MockAuthProvider: ThirdPartyAuthProvidable, @unchecked Sendable {
    static var preview: MockAuthProvider {
        MockAuthProvider()
    }
    
    func configure() {}
    func handleURL(_ url: URL) -> Bool { return false }
    func getToken(account: ThirdPartyAccount) async throws -> String { return "" }
    func signOut(account: ThirdPartyAccount) async throws {}
    func unlink(account: ThirdPartyAccount) async throws {}
}
