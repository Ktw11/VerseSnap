//
//  PermanentDiary.swift
//  Repository
//
//  Created by 공태웅 on 5/5/25.
//

import Foundation
import SwiftData

@Model
public final class PermanentDiary {
    @Attribute(.unique)
    public var id: String
    private(set) var imageURL: String
    private(set) var hashtags: String
    private(set) var createdAt: TimeInterval
    private(set) var verses: [String]
    private(set) var userId: String
    var isFavorite: Bool
    
    init(id: String, imageURL: String, hashtags: [String], createdAt: TimeInterval, verses: [String], userId: String, isFavorite: Bool) {
        self.id = id
        self.imageURL = imageURL
        self.hashtags = hashtags.joined(separator: ",")
        self.createdAt = createdAt
        self.verses = verses
        self.userId = userId
        self.isFavorite = isFavorite
    }
}
