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
    
    public init() {
        let schema = Schema([
            PersistDiary.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            let container = try ModelContainer(for: schema, configurations: [modelConfiguration])
            let modelContext = ModelContext(container)
            self.modelExecutor = DefaultSerialModelExecutor(modelContext: modelContext)
            self.modelContainer = container
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }
    
    public func save(_ diary: DiaryDTO) async throws {
        modelContext.insert(diary.toPersist)
        try modelContext.save()
    }
    
    public func save(_ diaries: [DiaryDTO]) async throws {
        for diary in diaries {
            modelContext.insert(diary.toPersist)
        }
        try modelContext.save()
    }
    
    public func retreiveDiariesByMonth(
        startTimestamp: TimeInterval,
        endTimestamp: TimeInterval,
        after: TimeInterval?,
        size: Int
    ) async throws -> [DiaryDTO] {
        let predicate: Predicate<PersistDiary>
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
        
        let fetchDescriptor = FetchDescriptor<PersistDiary>(
            predicate: predicate,
            sortBy: [.init(\.createdAt, order: .reverse),]
        )
        
        let results = try modelContext.fetch(fetchDescriptor)
        return Array(results.map { $0.toDTO }.prefix(size))
    }
}

private extension DiaryLocalDataSourceImpl {
    func reset() throws {
        try modelContext.delete(model: PersistDiary.self)
    }
}

private extension PersistDiary {
    var toDTO: DiaryDTO {
        .init(id: id, imageURL: imageURL, hashtags: hashtags, createdAt: createdAt, verse: verse, isFavorite: isFavorite)
    }
}

private extension DiaryDTO {
    var toPersist: PersistDiary {
        .init(id: id, imageURL: imageURL, hashtags: hashtags, createdAt: createdAt, verse: verse, isFavorite: isFavorite)
    }
}


@Model
private final class PersistDiary {
    @Attribute(.unique)
    private(set) var id: String
    private(set) var imageURL: String
    private(set) var hashtags: [String]
    private(set) var createdAt: TimeInterval
    private(set) var verse: String
    var isFavorite: Bool
    
    init(id: String, imageURL: String, hashtags: [String], createdAt: TimeInterval, verse: String, isFavorite: Bool) {
        self.id = id
        self.imageURL = imageURL
        self.hashtags = hashtags
        self.createdAt = createdAt
        self.verse = verse
        self.isFavorite = isFavorite
    }
}
