//
//  DiaryDTO.swift
//  Repository
//
//  Created by 공태웅 on 5/4/25.
//

import Foundation
import Domain

public struct DiaryDTO: Sendable {
    let id: String
    let imageURL: String
    let hashtags: [String]
    let createdAt: TimeInterval
    let verses: [String]
    let isFavorite: Bool
}

extension DiaryDTO {
    var toDomain: VerseDiary {
        .init(
            id: id,
            imageURL: imageURL,
            hashtags: hashtags,
            createdAt: createdAt,
            verses: verses,
            isFavorite: isFavorite
        )
    }
}
