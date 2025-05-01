//
//  ThirdPartyAuthProvidable.swift
//  Domain
//
//  Created by 공태웅 on 3/7/25.
//

import Foundation

public protocol ThirdPartyAuthProvidable: Sendable {
    @MainActor
    @discardableResult
    func handleURL(_ url: URL) -> Bool
    
    func getToken(account: ThirdPartyAccount) async throws -> String
    func signOut(account: ThirdPartyAccount) async throws
    func unlink(account: ThirdPartyAccount) async throws
}
