//
//  DiaryLocalDataSource.swift
//  Repository
//
//  Created by 공태웅 on 5/4/25.
//

import Foundation
import SwiftData

public protocol DiaryLocalDataSource: Sendable {
    func save(_ diary: DiaryDTO) async throws
    func save(_ diaries: [DiaryDTO]) async throws
    
    func retreiveDiariesByMonth(
        startTimestamp: TimeInterval,
        endTimestamp: TimeInterval,
        after: TimeInterval?,
        size: Int
    ) async throws -> DiaryFetchResultDTO
}

@ModelActor
public actor DiaryLocalDataSourceImpl: DiaryLocalDataSource {
    
    // MARK: Lifecycle
    
    public init(container: ModelContainer) {
        self.modelContainer = container
        self.modelExecutor = DefaultSerialModelExecutor(modelContext: ModelContext(container))
    }
    
    public func save(_ diary: DiaryDTO) async throws {
        try Task.checkCancellation()
        
        modelContext.insert(diary.toPermanent)
        try modelContext.save()
    }
    
    public func save(_ diaries: [DiaryDTO]) async throws {
        try Task.checkCancellation()
        
        for diary in diaries {
            modelContext.insert(diary.toPermanent)
        }
        try modelContext.save()
    }
    
    public func retreiveDiariesByMonth(
        startTimestamp: TimeInterval,
        endTimestamp: TimeInterval,
        after: TimeInterval?,
        size: Int
    ) async throws -> DiaryFetchResultDTO {
        let predicate: Predicate<PermanentDiary>
        if let after = after {
            predicate = #Predicate {
                $0.createdAt >= startTimestamp &&
                $0.createdAt < endTimestamp &&
                $0.createdAt < after
            }
        } else {
            predicate = #Predicate {
                $0.createdAt >= startTimestamp &&
                $0.createdAt < endTimestamp
            }
        }
        
        let fetchDescriptor = FetchDescriptor<PermanentDiary>(
            predicate: predicate,
            sortBy: [.init(\.createdAt, order: .reverse),]
        )
        
        try Task.checkCancellation()
        
        let results = try modelContext.fetch(fetchDescriptor)
        // 요구 쿼리보다 1개 더 늘림
        // 마지막 페이지인지 정확히 판단하기 위함
        let limit: Int = size + 1
        let diaries: [DiaryDTO] = Array(results.map { $0.toDTO }.prefix(limit))

        return DiaryFetchResultDTO(
            diaries: diaries.count == limit ? diaries.dropLast() : diaries,
            isLastPage: diaries.count < limit
        )
    }
}

private extension DiaryLocalDataSourceImpl {
    func reset() throws {
        try modelContext.delete(model: PermanentDiary.self)
    }
}

private extension PermanentDiary {
    var toDTO: DiaryDTO {
        .init(id: id,
              imageURL: imageURL,
              hashtags: hashtags.components(separatedBy: ","),
              createdAt: createdAt,
              verse: verse,
              isFavorite: isFavorite
        )
    }
}

private extension DiaryDTO {
    var toPermanent: PermanentDiary {
        .init(id: id, imageURL: imageURL, hashtags: hashtags, createdAt: createdAt, verse: verse, isFavorite: isFavorite)
    }
}
