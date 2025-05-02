//
//  MockVerseRepository.swift
//  Domain
//
//  Created by 공태웅 on 4/26/25.
//

import Foundation
@testable import Domain

final class MockVerseRepository: VerseRepository, @unchecked Sendable {
    
    var isGenerateVerseCalled = false
    var requestedImageURLString: String?
    var requestedIsKorean: Bool?
    var requestedHashtags: [String]?
    var expectedGenerateVerseInfo: GeneratedVerseInfo?
    var expectedGenerateVerseError: Error?
    
    func generateVerse(imageURLString: String, isKorean: Bool, hashtags: [String]) async throws -> GeneratedVerseInfo {
        isGenerateVerseCalled = true
        requestedImageURLString = imageURLString
        requestedIsKorean = isKorean
        requestedHashtags = hashtags
        
        if let expectedGenerateVerseError {
            throw expectedGenerateVerseError
        } else if let expectedGenerateVerseInfo {
            return expectedGenerateVerseInfo
        } else {
            throw TestError.notImplemented
        }
    }
}
