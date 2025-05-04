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
    
    private typealias Request = VerseAPI.Request
    
    // MARK: Methods
    
    public func generate(imageData: Data, isKorean: Bool) async throws -> GeneratedVerseInfo {
        let request: Request.GenerateVerse = .init(
            imageData: imageData,
            isKorean: isKorean
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
