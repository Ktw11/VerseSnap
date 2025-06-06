//
//  MockDiaryRepository.swift
//  Domain
//
//  Created by 공태웅 on 5/4/25.
//

import Foundation
@testable import Domain

final class MockDiaryRepository: DiaryRepository, @unchecked Sendable {
    var isSaveCalled: Bool = false
    var requestedSaveVerses: [String]?
    var requestedSaveImageURL: String?
    var requestedSaveHashtags: [String]?
    var expectedSaveError: Error?
    var expectedSave: VerseDiary?
    
    var isFetchDiariesCalled: Bool = false
    var requestedFetchDiariesStartTimestamp: TimeInterval?
    var requestedFetchDiariesEndTimestamp: TimeInterval?
    var requestedFetchDiariesCursor: DiaryCursor?
    var expectedFetchDiaries: DiaryFetchResult?
    var expectedFetchDiariesError: Error?
    
    var isFetchDiariesAllCalled: Bool = false
    var requestedFetchDiariesAllCursor: DiaryCursor?
    var expectedFetchDiariesAll: DiaryFetchResult?
    var expectedFetchDiariesAllError: Error?
    
    var isUpdateFavoriteCalled: Bool = false
    var requestedUpdateFavoriteTo: Bool?
    var requestedUpdateFavoriteId: String?
    var expectedUpdateFavoriteError: Error?
    
    var isDeleteAllCalled: Bool = false
    var expectedDeleteAllError: Error?
    
    func save(verses: [String], imageURL: String, hashtags: [String]) async throws -> VerseDiary {
        isSaveCalled = true
        requestedSaveVerses = verses
        requestedSaveImageURL = imageURL
        requestedSaveHashtags = hashtags
        
        if let expectedSave {
            return expectedSave
        } else if let expectedSaveError {
            throw expectedSaveError
        } else {
            throw TestError.notImplemented
        }
    }
    
    func fetchDiaries(
        startTimestamp: TimeInterval,
        endTimestamp: TimeInterval,
        after cursor: DiaryCursor
    ) async throws -> DiaryFetchResult {
        isFetchDiariesCalled = true
        requestedFetchDiariesStartTimestamp = startTimestamp
        requestedFetchDiariesEndTimestamp = endTimestamp
        requestedFetchDiariesCursor = cursor
        
        if let expectedFetchDiaries {
            return expectedFetchDiaries
        } else if let expectedFetchDiariesError {
            throw expectedFetchDiariesError
        } else {
            throw TestError.notImplemented
        }
    }
    
    func fetchDiariesAll(after cursor: Domain.DiaryCursor) async throws -> Domain.DiaryFetchResult {
        isFetchDiariesAllCalled = true
        requestedFetchDiariesAllCursor = cursor
        
        if let expectedFetchDiariesAll {
            return expectedFetchDiariesAll
        } else if let expectedFetchDiariesAllError {
            throw expectedFetchDiariesAllError
        } else {
            throw TestError.notImplemented
        }
    }
    
    func updateFavorite(to isFavorite: Bool, id: String) async throws {
        isUpdateFavoriteCalled = true
        requestedUpdateFavoriteTo = isFavorite
        requestedUpdateFavoriteId = id
        
        if let expectedUpdateFavoriteError {
            throw expectedUpdateFavoriteError
        }
    }
    
    func deleteAll() async throws {
        isDeleteAllCalled = true
        
        if let expectedDeleteAllError {
            throw expectedDeleteAllError
        }
    }
}
