//
//  VerseRepositoryImpl.swift
//  Repository
//
//  Created by 공태웅 on 4/24/25.
//

import Foundation
import VSNetwork
import Domain

public final class VerseRepositoryImpl: VerseRepository {
    
    // MARK: Lifecycle
    
    public init(networkProvider: NetworkProvidable) {
        self.networkProvider = networkProvider
    }
    
    // MARK: Properties
    
    private let networkProvider: NetworkProvidable
    
    // MARK: Methods
    
    public func generateVerse(imageData: Data, isKorean: Bool, hashtags: [String]) async throws -> GeneratedVerseInfo {
        let request: VerseAPI.Request.GenerateVerse = .init(
            imageData: imageData,
            isKorean: isKorean,
            hashtags: hashtags
        )
        let api: API = VerseAPI.generate(request)
        
        do {
            return try await networkProvider.request(api: api)
                .map(GeneratedVerseInfo.self)
        } catch let error as NetworkError {
            if case let .badRequest(code) = error, code == 429 {
                throw DomainError.exceedDailyLimit
            } else {
                throw DomainError.unknown
            }
        }
    }
}
