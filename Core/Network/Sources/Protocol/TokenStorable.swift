//
//  TokenStorable.swift
//  Network
//
//  Created by 공태웅 on 3/2/25.
//

import Foundation

public protocol TokenStorable: Sendable, AnyObject {
    var accessToken: String? { get async }
    var refreshToken: String? { get async }
    
    func updateTokens(accessToken: String, refreshToken: String) async
}
