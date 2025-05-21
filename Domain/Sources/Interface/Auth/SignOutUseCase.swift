//
//  SignOutUseCase.swift
//  Domain
//
//  Created by 공태웅 on 5/12/25.
//

import Foundation

public protocol SignOutUseCase: Sendable {
    func signOut() async throws
    func deleteAccount() async throws
}
