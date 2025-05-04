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
}

private extension VerseDiary {
    var toDTO: DiaryDTO {
        DiaryDTO(id: id, imageURL: imageURL, hashtags: hashtags, createdAt: createdAt, verse: verse, isFavorite: isFavorite)
    }
}
