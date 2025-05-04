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
        verse: String,
        remainingLimit: Int
    ) {
        self.verse = verse
        self.remainingLimit = remainingLimit
    }
    
    // MARK: Properties

    public let verse: String
    public let remainingLimit: Int
}
