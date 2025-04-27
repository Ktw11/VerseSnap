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
    var requestedImageData: Data?
    var requestedIsKorean: Bool?
    var expectedGenerateVerse: VerseResult?
    var expectedGenerateVerseError: Error?
    
    func generateVerse(imageData: Data, isKorean: Bool) async throws -> VerseResult {
        isGenerateVerseCalled = true
        requestedImageData = imageData
        requestedIsKorean = isKorean
        
        if let expectedGenerateVerseError {
            throw expectedGenerateVerseError
        } else if let expectedGenerateVerse {
            return expectedGenerateVerse
        } else {
            throw TestError.notImplemented
        }
    }
}
