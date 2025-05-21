//
//  SignOutUseCasePreview.swift
//  PreviewSupport
//
//  Created by 공태웅 on 5/14/25.
//

import Foundation
import Domain

public final class SignOutUseCasePreview: SignOutUseCase, @unchecked Sendable {
    
    // MARK: Properties
    
    public var expectedSignOutError: Error?
    public var expectedDeleteAccountError: Error?
    
    // MARK: Methods
    
    public func signOut() async throws {
        if let expectedSignOutError {
            throw expectedSignOutError
        }
    }
    
    public func deleteAccount() async throws {
        if let expectedDeleteAccountError {
            throw expectedDeleteAccountError
        }
    }
}

public extension SignOutUseCasePreview {
    static var preview: SignOutUseCasePreview {
        SignOutUseCasePreview()
    }
}
