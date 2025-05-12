//
//  UserRepository.swift
//  Domain
//
//  Created by 공태웅 on 5/11/25.
//

import Foundation

public protocol UserRepository: Sendable {
    func updateNickname(to nickname: String) async throws
}
