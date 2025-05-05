//
//  PermanentSignInInfo.swift
//  Repository
//
//  Created by 공태웅 on 5/5/25.
//

import Foundation
import SwiftData

@Model
public final class PermanentSignInInfo {
    @Attribute(.unique)
    var refreshToken: String
    var signInType: String
    
    init(refreshToken: String, signInType: String) {
        self.refreshToken = refreshToken
        self.signInType = signInType
    }
}
