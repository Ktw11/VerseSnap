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
    
    public func generateVerse(imageData: Data, isKorean: Bool) async throws -> VerseResult {
        let api = VerseAPI.generate(imageData: imageData, isKorean: isKorean)
        
        do {
            return try await networkProvider.request(api: api)
                .map(VerseResult.self)
        } catch let error as NetworkError {
            if case let .badRequest(code) = error, code == 429 {
                throw VerseError.exceedDailyLimit
            } else {
                throw VerseError.unknown
            }
        }
    }
}
