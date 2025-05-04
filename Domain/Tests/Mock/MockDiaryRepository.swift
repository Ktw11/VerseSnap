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
    
    func save(verse: String, imageURL: String, hashtags: [String]) async throws {
        isSaveCalled = true
        requestedSaveVerse = verse
        requestedSaveImageURL = imageURL
        requestedSaveHashtags = hashtags
        
        if let expectedSaveError {
            throw expectedSaveError
        }
    }
}
