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
    
    public func generateVerse(imageURLString: String, isKorean: Bool, hashtags: [String]) async throws -> GeneratedVerseInfo {
        let request: VerseAPI.Request.GenerateVerse = .init(
            imageURLString: imageURLString,
            isKorean: isKorean,
            hashtags: hashtags
        )
        let api: API = VerseAPI.generate(request)
        
        do {
            let data = try await networkProvider.request(api: api)
            return try JSONDecoder().decode(GeneratedVerseInfo.self, from: data)
        } catch let error as NetworkError {
            if case let .badRequest(code) = error, code == 429 {
                throw DomainError.exceedDailyLimit
            } else {
                throw DomainError.unknown
            }
        } catch let error as DecodingError {
            throw DomainError.decodingFailed(error)
        } catch {
            throw DomainError.unknown
        }
    }
}
