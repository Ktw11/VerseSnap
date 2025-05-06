//
//  DiaryCursor.swift
//  Domain
//
//  Created by 공태웅 on 5/4/25.
//

import Foundation

public struct DiaryCursor: Sendable {
    
    // MARK: Lifecycle
    
    public init(size: Int, lastCreatedAt: TimeInterval?) {
        self.size = size
        self.lastCreatedAt = lastCreatedAt
    }
    
    // MARK: Properties
    
    public let size: Int
    public let lastCreatedAt: TimeInterval?
}
