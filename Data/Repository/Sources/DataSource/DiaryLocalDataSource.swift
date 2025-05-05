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
    ) async throws -> [DiaryDTO]
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
    ) async throws -> [DiaryDTO] {
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
        return Array(results.map { $0.toDTO }.prefix(size))
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
