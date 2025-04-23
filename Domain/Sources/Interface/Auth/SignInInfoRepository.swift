//
//  SignInInfoRepository.swift
//  Domain
//
//  Created by 공태웅 on 3/2/25.
//

import Foundation

public protocol SignInInfoRepository: Sendable {
    func retrieve() async -> SignInInfo?
    func save(info: SignInInfo) async throws
    func reset() async throws
}
