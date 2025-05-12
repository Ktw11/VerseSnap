//
//  TokenUpdatable.swift
//  Domain
//
//  Created by 공태웅 on 4/27/25.
//

import Foundation

public protocol TokenUpdatable: Sendable {
    func updateTokens(accessToken: String?, refreshToken: String?) async
}
