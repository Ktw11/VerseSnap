//
//  MockVerseRepository.swift
//  Domain
//
//  Created by 공태웅 on 4/26/25.
//

import Foundation
@testable import Domain

final class MockVerseRepository: VerseRepository, @unchecked Sendable {
    
    var isGenerateCalled = false
    var requestedGenerateImageData: Data?
    var requestedGenerateIsKorean: Bool?
    var expectedGenerateInfo: GeneratedVerseInfo?
    var expectedGenerateError: Error?
    
    var isSaveCalled: Bool = false
    var requestedSaveVerse: String?
    var requestedSaveImageURL: String?
    var requestedSaveHashtags: [String]?
    var expectedSaveResult: VerseDiary?
    var expectedSaveError: Error?
    
    func generate(imageData: Data, isKorean: Bool) async throws -> GeneratedVerseInfo {
        isGenerateCalled = true
        requestedGenerateImageData = imageData
        requestedGenerateIsKorean = isKorean
        
        if let expectedGenerateError {
            throw expectedGenerateError
        } else if let expectedGenerateInfo {
            return expectedGenerateInfo
        } else {
            throw TestError.notImplemented
        }
    }
    
    func save(verse: String, imageURL: String, hashtags: [String]) async throws -> VerseDiary {
        isSaveCalled = true
        requestedSaveVerse = verse
        requestedSaveImageURL = imageURL
        requestedSaveHashtags = hashtags
        
        if let expectedSaveError {
            throw expectedSaveError
        } else if let expectedSaveResult {
            return expectedSaveResult
        } else {
            throw TestError.notImplemented
        }
    }
}
