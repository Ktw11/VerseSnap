//
//  DiaryRepository.swift
//  Domain
//
//  Created by 공태웅 on 5/4/25.
//

import Foundation

public protocol DiaryRepository: Sendable {
    func save(verse: String, imageURL: String, hashtags: [String]) async throws -> VerseDiary
    func fetchDiaries(
        startTimestamp: TimeInterval,
        endTimestamp: TimeInterval,
        after cursor: DiaryCursor
    ) async throws -> DiaryFetchResult
    func fetchDiariesAll(after cursor: DiaryCursor) async throws -> DiaryFetchResult
    func updateFavorite(to isFavorite: Bool, id: String) async throws
}
