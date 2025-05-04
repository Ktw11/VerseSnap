//
//  VerseDiary.swift
//  Domain
//
//  Created by 공태웅 on 5/4/25.
//

import Foundation

public struct VerseDiary: Decodable, Equatable, Sendable {
    // MARK: Lifecycle
    
    public init(
        imageURL: String,
        hashtags: [String],
        createdAt: TimeInterval,
        verse: String,
        isFavorite: Bool
    ) {
        self.imageURL = imageURL
        self.hashtags = hashtags
        self.createdAt = createdAt
        self.verse = verse
        self.isFavorite = isFavorite
    }
    
    // MARK: Properties
    
    public let imageURL: String
    public let hashtags: [String]
    public let createdAt: TimeInterval
    public let verse: String
    public let isFavorite: Bool
}
