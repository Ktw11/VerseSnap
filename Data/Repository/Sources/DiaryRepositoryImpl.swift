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
        userId: String,
        networkProvider: NetworkProvidable,
        localDataSource: DiaryLocalDataSource
    ) {
        self.userId = userId
        self.networkProvider = networkProvider
        self.localDataSource = localDataSource
    }
    
    // MARK: Properties
    
    private let userId: String
    private let networkProvider: NetworkProvidable
    private let localDataSource: DiaryLocalDataSource
    
    private typealias Request = VerseAPI.Request
    
    // MARK: Methods
    
    public func save(verse: String, imageURL: String, hashtags: [String]) async throws -> VerseDiary {
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
        
        let userId: String = self.userId
        Task { [result] in
            try? await localDataSource.save(result.toDTO, userId: userId)
        }
        
        return result
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
            size: cursor.size,
            userId: userId
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
            
            try Task.checkCancellation()
            
            return try await fetchRemote(api: VerseAPI.listFilter(request))
        }
    }
    
    public func fetchDiariesAll(after cursor: DiaryCursor) async throws -> DiaryFetchResult {
        try Task.checkCancellation()
        
        let localResult: DiaryFetchResultDTO? = try? await localDataSource.retreiveAllDiaries(
            after: cursor.lastCreatedAt,
            size: cursor.size,
            userId: userId
        )
        
        if let localResult, !localResult.diaries.isEmpty {
            return localResult.toDomain
        } else {
            let request: Request.ListAll = .init(
                lastCreatedAt: cursor.lastCreatedAt,
                size: cursor.size
            )
            
            try Task.checkCancellation()
            
            return try await fetchRemote(api: VerseAPI.listAll(request))
        }
    }
    
    public func updateFavorite(to isFavorite: Bool, id: String) async throws {
        let request: VerseAPI.Request.UpdateFavorite = .init(id: id, isFavorite: isFavorite)
        let api: API = VerseAPI.updateFavorite(request)
        
        try Task.checkCancellation()
        _ = try await networkProvider.request(api: api)
        
        Task.detached { [localDataSource] in
            try Task.checkCancellation()
            try? await localDataSource.updateFavorite(to: isFavorite, id: id)
        }
    }
    
    public func deleteAll() async throws {
        try await localDataSource.deleteAll()
    }
}

private extension DiaryRepositoryImpl {
    func fetchRemote(api: API) async throws -> DiaryFetchResult {
        try Task.checkCancellation()
        
        let data = try await networkProvider.request(api: api)
        
        try Task.checkCancellation()
        
        let remoteResult = try JSONDecoder().decode(DiaryFetchResult.self, from: data)
        try await localDataSource.save(remoteResult.diaries.map(\.toDTO), userId: userId)
        return remoteResult
    }
}

private extension VerseDiary {
    var toDTO: DiaryDTO {
        DiaryDTO(id: id, imageURL: imageURL, hashtags: hashtags, createdAt: createdAt, verse: verse, isFavorite: isFavorite)
    }
}
