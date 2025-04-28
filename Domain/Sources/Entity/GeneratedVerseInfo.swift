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
        base64Image: String,
        hashtags: [String],
        createdAt: TimeInterval,
        verse: String,
        isFavorite: Bool,
        remainingLimit: Int
    ) {
        self.base64Image = base64Image
        self.hashtags = hashtags
        self.createdAt = createdAt
        self.verse = verse
        self.isFavorite = isFavorite
        self.remainingLimit = remainingLimit
    }
    
    // MARK: Properties
    
    public let base64Image: String
    public let hashtags: [String]
    public let createdAt: TimeInterval
    public let verse: String
    public let isFavorite: Bool
    public let remainingLimit: Int
}
