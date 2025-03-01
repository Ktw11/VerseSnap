//
//  AppleAuthHelper.swift
//  Authentication
//
//  Created by 공태웅 on 3/1/25.
//

import Foundation
import AuthenticationServices

final class AppleAuthHelper: NSObject, ThirdPartyAuthHelpable {
    
    // MARK: Definitions
    
    private actor State {
        var authContinuation: CheckedContinuation<ASAuthorization, Error>? = nil

        func setAuthContinuation(to continuation: CheckedContinuation<ASAuthorization, Error>?) {
            authContinuation = continuation
        }
    }
    
    // MARK: Properties
    
    private let state: State = .init()
    
    // MARK: Methods
    
    @MainActor func configure() {
        // do nothing
    }
    
    @MainActor func handleURL(_ url: URL) -> Bool {
        false
    }
    
    func getToken() async throws -> String {
        let authorization = try await getAuthorizationFromApple()
        return try getTokenString(from: authorization)
    }
    
    func signOut() throws {
        // do nothing
    }
    
    func unlink() throws {
        // do nothing
    }
}

private extension AppleAuthHelper {
    func getAuthorizationFromApple() async throws -> ASAuthorization {
        try await withCheckedThrowingContinuation { continuation in
            Task {
                await self.state.setAuthContinuation(to: continuation)
                await self.performAuthRequest()
            }
        }
    }
    
    func performAuthRequest() async {
        let nonce = CryptoUtil.makeRandomNonce()
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = CryptoUtil.sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
    }
    
    func getTokenString(from authorization: ASAuthorization) throws -> String {
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential,
              let authCodeData = credential.authorizationCode,
              let authCodeString = String(data: authCodeData, encoding: .utf8) else {
            throw AuthProviderError.failedToGetToken
        }
        return authCodeString
    }
}

extension AppleAuthHelper: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        Task {
            await self.state.authContinuation?.resume(returning: authorization)
            await self.state.setAuthContinuation(to: nil)
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        Task {
            await self.state.authContinuation?.resume(throwing: error)
            await self.state.setAuthContinuation(to: nil)
        }
    }
}
