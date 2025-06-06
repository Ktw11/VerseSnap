//
//  ThirdPartyAuthHelpable.swift
//  Authentication
//
//  Created by 공태웅 on 3/1/25.
//

import Foundation

protocol ThirdPartyAccountAuthHelpable: Sendable {
    @MainActor func handleURL(_ url: URL) -> Bool
    func getToken() async throws -> String
    func signOut() async throws
    func unlink() async throws
}
