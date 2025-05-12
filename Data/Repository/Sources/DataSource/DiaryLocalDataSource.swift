//
//  DiaryLocalDataSource.swift
//  Repository
//
//  Created by 공태웅 on 5/4/25.
//

import Foundation
import SwiftData

public protocol DiaryLocalDataSource: Sendable {
    func save(_ diary: DiaryDTO, userId: String) async throws
    func save(_ diaries: [DiaryDTO], userId: String) async throws
    
    func retreiveDiariesByMonth(
        startTimestamp: TimeInterval,
        endTimestamp: TimeInterval,
        after: TimeInterval?,
        size: Int,
        userId: String
    ) async throws -> DiaryFetchResultDTO
    func retreiveAllDiaries(after: TimeInterval?, size: Int, userId: String) async throws -> DiaryFetchResultDTO
    func updateFavorite(to isFavorite: Bool, id: String) async throws
    func deleteAll() async throws
}

@ModelActor
public actor DiaryLocalDataSourceImpl: DiaryLocalDataSource {
    
    // MARK: Lifecycle
    
    public init(container: ModelContainer) {
        self.modelContainer = container
        self.modelExecutor = DefaultSerialModelExecutor(modelContext: ModelContext(container))
    }
    
    public func save(_ diary: DiaryDTO, userId: String) async throws {
        try Task.checkCancellation()
        
        modelContext.insert(diary.toPermanent(userId: userId))
        try modelContext.save()
    }
    
    public func save(_ diaries: [DiaryDTO], userId: String) async throws {
        try Task.checkCancellation()
        
        for diary in diaries {
            modelContext.insert(diary.toPermanent(userId: userId))
        }
        try modelContext.save()
    }
    
    public func retreiveDiariesByMonth(
        startTimestamp: TimeInterval,
        endTimestamp: TimeInterval,
        after: TimeInterval?,
        size: Int,
        userId: String
    ) async throws -> DiaryFetchResultDTO {
        let predicate: Predicate<PermanentDiary>
        if let after {
            predicate = #Predicate {
                $0.userId == userId &&
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
        
        try Task.checkCancellation()
        
        return try await fetchResult(predicate, size: size)
    }
    
    public func retreiveAllDiaries(after: TimeInterval?, size: Int, userId: String) async throws -> DiaryFetchResultDTO {
        let predicate: Predicate<PermanentDiary>?
        if let after {
            predicate = #Predicate {
                $0.userId == userId &&
                $0.createdAt < after
            }
        } else {
            predicate = nil
        }
        
        try Task.checkCancellation()
        
        return try await fetchResult(predicate, size: size)
    }
    
    public func updateFavorite(to isFavorite: Bool, id: String) async throws {
        let fetchDescriptor = FetchDescriptor<PermanentDiary>(
            predicate: #Predicate { $0.id == id }
        )
        
        guard let diary = try modelContext.fetch(fetchDescriptor).first else { return }
        diary.isFavorite = isFavorite
        try modelContext.save()
    }
    
    public func deleteAll() async throws {
        let descriptor = FetchDescriptor<PermanentDiary>()
        let diaries = try modelContext.fetch(descriptor)
        diaries.forEach { modelContext.delete($0) }
        try modelContext.save()
    }
}

private extension DiaryLocalDataSourceImpl {
    
    func fetchResult(_ predicate: Predicate<PermanentDiary>?, size: Int) async throws -> DiaryFetchResultDTO{
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

private extension PermanentDiary {
    var toDTO: DiaryDTO {
        .init(
            id: id,
            imageURL: imageURL,
            hashtags: hashtags.components(separatedBy: ",").filter { !$0.isEmpty },
            createdAt: createdAt,
            verse: verse,
            isFavorite: isFavorite
        )
    }
}

private extension DiaryDTO {
    func toPermanent(userId: String) -> PermanentDiary {
        .init(
            id: id,
            imageURL: imageURL,
            hashtags: hashtags,
            createdAt: createdAt,
            verse: verse,
            userId: userId,
            isFavorite: isFavorite
        )
    }
}
