//
//  DiaryRepositoryImpl.swift
//  Repository
//
//  Created by 공태웅 on 5/4/25.
//

import Foundation
import VSNetwork
import Domain

public final class DiaryRepositoryImpl: DiaryRepository {
    
    // MARK: Lifecycle
    
    public init(networkProvider: NetworkProvidable) {
        self.networkProvider = networkProvider
    }
    
    // MARK: Properties
    
    private let networkProvider: NetworkProvidable
    
    private typealias Request = VerseAPI.Request
    
    // MARK: Methods
    
    public func save(verse: String, imageURL: String, hashtags: [String]) async throws -> VerseDiary {
        let request: Request.SaveVerseDiary = .init(verse: verse, imageURL: imageURL, hashtags: hashtags)
        let api: API = VerseAPI.save(request)
        
        do {
            let data = try await networkProvider.request(api: api)
            return try JSONDecoder().decode(VerseDiary.self, from: data)
        } catch let error as DecodingError {
            throw DomainError.decodingFailed(error)
        } catch {
            throw DomainError.unknown
        }
    }
}
