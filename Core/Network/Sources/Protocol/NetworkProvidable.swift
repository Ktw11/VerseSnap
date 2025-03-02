//
//  NetworkProvidable.swift
//  Network
//
//  Created by 공태웅 on 3/2/25.
//

import Foundation

public protocol NetworkProvidable: Sendable {
    func request(api: API) async throws -> Data
    func setTokenStore(_ store: TokenStorable) async
    func setTokenRefresher(_ refresher: TokenRefreshable) async
}
