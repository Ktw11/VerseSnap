//
//  GeneratedVerseInfo.swift
//  Domain
//
//  Created by 공태웅 on 4/24/25.
//

import Foundation

public struct GeneratedVerseInfo: Decodable, Equatable, Sendable {
    // MARK: Lifecycle
    
    public init(
        verses: [String],
        remainingLimit: Int
    ) {
        self.verses = verses
        self.remainingLimit = remainingLimit
    }
    
    // MARK: Properties

    public let verses: [String]
    public let remainingLimit: Int
}
