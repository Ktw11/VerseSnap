//
//  TokenRefreshable.swift
//  Network
//
//  Created by 공태웅 on 3/2/25.
//

import Foundation

public protocol TokenRefreshable: Sendable, AnyObject {
    func refreshTokens() async throws
}
