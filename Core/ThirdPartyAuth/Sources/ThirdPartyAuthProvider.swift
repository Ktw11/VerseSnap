//
//  ThirdPartyAuthProvider.swift
//  Authentication
//
//  Created by 공태웅 on 3/1/25.
//

import Foundation
import Domain

public actor ThirdPartyAuthProvider: ThirdPartyAuthProvidable {
    
    // MARK: Lifecycle
    
    public init(accounts: Set<ThirdPartyAccount>) {
        self.helpers = Dictionary(uniqueKeysWithValues: accounts.map { ($0, $0.getHelper) })
    }
    
    // MARK: Properties
    
    private var recentSignedInAccount: ThirdPartyAccount?
    private let helpers: [ThirdPartyAccount: ThirdPartyAccountAuthHelpable]
    
    // MARK: Methods
    
    @MainActor
    @discardableResult
    public func handleURL(_ url: URL) -> Bool {
        helpers.values.first(where: { $0.handleURL(url) }) != nil
    }
    
    public func getToken(account: ThirdPartyAccount) async throws -> String {
        guard let helper = helpers[account] else { throw ThirdPartyAuthProviderError.invalidAccount }
        return try await helper.getToken()
    }
    
    public func didSignIn(account: ThirdPartyAccount) async {
        recentSignedInAccount = account
    }
    
    public func signOut() async throws {
        guard let account = recentSignedInAccount else { throw ThirdPartyAuthProviderError.notFoundAccount }
        guard let helper = helpers[account] else { throw ThirdPartyAuthProviderError.invalidAccount }
        
        try await helper.signOut()
        recentSignedInAccount = nil
    }
    
    public func unlink() async throws {
        guard let account = recentSignedInAccount else { throw ThirdPartyAuthProviderError.notFoundAccount }
        guard let helper = helpers[account] else { throw ThirdPartyAuthProviderError.invalidAccount }
        
        try await helper.unlink()
        recentSignedInAccount = nil
    }
}

private extension ThirdPartyAccount {
    var getHelper: ThirdPartyAccountAuthHelpable {
        switch self {
        case .apple:
            AppleAccountAuthHelper()
        case .kakao:
            KakaoAccountAuthHelper()
        }
    }
}
