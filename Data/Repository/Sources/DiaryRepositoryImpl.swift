//
//  DiaryRepositoryImpl.swift
//  Repository
//
//  Created by 공태웅 on 5/4/25.
//

import Foundation
import VSNetwork
import Domain

public actor DiaryRepositoryImpl: DiaryRepository {
    
    // MARK: Lifecycle
    
    public init(
        networkProvider: NetworkProvidable,
        localDataSource: DiaryLocalDataSource
    ) {
        self.networkProvider = networkProvider
        self.localDataSource = localDataSource
    }
    
    // MARK: Properties
    
    private let networkProvider: NetworkProvidable
    private let localDataSource: DiaryLocalDataSource
    
    private typealias Request = VerseAPI.Request
    
    // MARK: Methods
    
    public func save(verse: String, imageURL: String, hashtags: [String]) async throws {
        let request: Request.SaveVerseDiary = .init(verse: verse, imageURL: imageURL, hashtags: hashtags)
        let api: API = VerseAPI.save(request)
        
        let result: VerseDiary
        do {
            let data = try await networkProvider.request(api: api)
            result = try JSONDecoder().decode(VerseDiary.self, from: data)
        } catch let error as DecodingError {
            throw DomainError.decodingFailed(error)
        } catch {
            throw DomainError.unknown
        }
        
        Task { [result] in
            try? await localDataSource.save(result.toDTO)
        }
    }
    
    public func fetchDiaries(
        startTimestamp: TimeInterval,
        endTimestamp: TimeInterval,
        after cursor: DiaryCursor
    ) async throws -> DiaryFetchResult {
        try Task.checkCancellation()
        
        let localResult: DiaryFetchResultDTO? = try? await localDataSource.retreiveDiariesByMonth(
            startTimestamp: startTimestamp,
            endTimestamp: endTimestamp,
            after: cursor.lastCreatedAt,
            size: cursor.size
        )

        if let localResult, !localResult.diaries.isEmpty {
            return localResult.toDomain
        } else {
            let request: Request.ListFilter = .init(
                startTimestamp: startTimestamp,
                endTimestamp: endTimestamp,
                lastCreatedAt: cursor.lastCreatedAt,
                size: cursor.size
            )
            let api: API = VerseAPI.listFilter(request)
            let data = try await networkProvider.request(api: api)
            let remoteResult = try JSONDecoder().decode(DiaryFetchResult.self, from: data)
            
            try Task.checkCancellation()
            
            try await localDataSource.save(remoteResult.diaries.map(\.toDTO))
            return remoteResult
        }
    }
}

private extension VerseDiary {
    var toDTO: DiaryDTO {
        DiaryDTO(id: id, imageURL: imageURL, hashtags: hashtags, createdAt: createdAt, verse: verse, isFavorite: isFavorite)
    }
}
