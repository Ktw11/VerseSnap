//
//  TokenStore.swift
//  App
//
//  Created by 공태웅 on 4/27/25.
//

import Foundation
import VSNetwork
import Domain

actor TokenStore: TokenStorable, TokenUpdatable {
    
    // MARK: Properties
    
    var accessToken: String?
    var refreshToken: String?
    
    func updateTokens(accessToken: String, refreshToken: String) async {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
}
