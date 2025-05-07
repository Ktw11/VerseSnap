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
    var requestedSaveVerse: String?
    var requestedSaveImageURL: String?
    var requestedSaveHashtags: [String]?
    var expectedSaveError: Error?
    
    var isFetchDiariesCalled: Bool = false
    var requestedFetchDiariesStartTimestamp: TimeInterval?
    var requestedFetchDiariesEndTimestamp: TimeInterval?
    var requestedFetchDiariesCursor: DiaryCursor?
    var expectedFetchDiaries: DiaryFetchResult?
    var expectedFetchDiariesError: Error?
    
    func save(verse: String, imageURL: String, hashtags: [String]) async throws {
        isSaveCalled = true
        requestedSaveVerse = verse
        requestedSaveImageURL = imageURL
        requestedSaveHashtags = hashtags
        
        if let expectedSaveError {
            throw expectedSaveError
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
}
