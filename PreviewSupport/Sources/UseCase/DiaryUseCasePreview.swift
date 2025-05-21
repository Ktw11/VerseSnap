//
//  DiaryUseCasePreview.swift
//  PreviewSupport
//
//  Created by 공태웅 on 5/4/25.
//

import Foundation
import UIKit
import Domain

public final class DiaryUseCasePreview: DiaryUseCase, @unchecked Sendable {

    // MARK: Properties

    public var saveLoadingSeconds: Int?
    
    public var expectedDiaries: DiaryFetchResult?
    public var expectedDiariesError: Error?
    
    public var expectedDiariesAll: DiaryFetchResult?
    public var expectedDiariesAllError: Error?
    
    public var expectedUpdateFavoriteError: Error?
    
    // MARK: Methods
    
    public func save(verses: [String], image: UIImage, hashtags: [String]) async throws {
        if let saveLoadingSeconds {
            try await Task.sleep(nanoseconds: UInt64(saveLoadingSeconds * 1000_000_000))
        }
    }
    
    public func fetchDiaries(year: Int, month: Int, after cursor: DiaryCursor) async throws -> DiaryFetchResult {
        if let expectedDiaries {
            return expectedDiaries
        } else if let expectedDiariesError {
            throw expectedDiariesError
        } else {
            throw DomainError.cancelled
        }
    }
    
    public func fetchDiariesAll(after cursor: Domain.DiaryCursor) async throws -> Domain.DiaryFetchResult {
        if let expectedDiariesAll {
            return expectedDiariesAll
        } else if let expectedDiariesAllError {
            throw expectedDiariesAllError
        } else {
            throw DomainError.cancelled
        }
    }
    
    public func updateFavorite(to isFavorite: Bool, id: String) async throws {
        if let expectedUpdateFavoriteError {
            throw expectedUpdateFavoriteError
        }
    }
}

public extension DiaryUseCasePreview {
    static var preview: DiaryUseCasePreview {
        DiaryUseCasePreview()
    }
}
