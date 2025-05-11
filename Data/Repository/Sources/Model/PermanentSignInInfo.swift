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
    
    // MARK: Lifecycle
    
    init(refreshToken: String, signInType: String, userId: String) {
        self.refreshToken = refreshToken
        self.signInType = signInType
        self.userId = userId
    }
    
    // MARK: Properties
    
    @Attribute(.unique) var refreshToken: String
    var signInType: String
    @Attribute(.unique) var userId: String
    
    @Relationship(deleteRule: .cascade)
    var diaries: [PermanentDiary]?
}
