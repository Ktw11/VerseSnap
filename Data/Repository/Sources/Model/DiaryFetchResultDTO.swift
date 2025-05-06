//
//  DiaryFetchResultDTO.swift
//  Repository
//
//  Created by 공태웅 on 5/6/25.
//

import Foundation
import Domain

public struct DiaryFetchResultDTO: Sendable {
    let diaries: [DiaryDTO]
    let isLastPage: Bool
}

extension DiaryFetchResultDTO {
    var toDomain: DiaryFetchResult {
        .init(
            diaries: diaries.map { $0.toDomain },
            isLastPage: isLastPage
        )
    }
}
