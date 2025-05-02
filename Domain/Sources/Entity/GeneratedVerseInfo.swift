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
        imageURL: String,
        hashtags: [String],
        createdAt: TimeInterval,
        verse: String,
        isFavorite: Bool,
        remainingLimit: Int
    ) {
        self.imageURL = imageURL
        self.hashtags = hashtags
        self.createdAt = createdAt
        self.verse = verse
        self.isFavorite = isFavorite
        self.remainingLimit = remainingLimit
    }
    
    // MARK: Properties
    
    public let imageURL: String
    public let hashtags: [String]
    public let createdAt: TimeInterval
    public let verse: String
    public let isFavorite: Bool
    public let remainingLimit: Int
}
