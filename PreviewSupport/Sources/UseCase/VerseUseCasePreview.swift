//
//  VerseUseCasePreview.swift
//  PreviewSupport
//
//  Created by 공태웅 on 5/1/25.
//

import Foundation
import UIKit
import Domain

public final class VerseUseCasePreview: VerseUseCase, @unchecked Sendable {

    // MARK: Properties
    
    public var verseResult: GeneratedVerseInfo?
    public var generateLoadingSeconds: Int?
    
    // MARK: Methods
    
    public func generate(image: UIImage) async throws -> GeneratedVerseInfo {
        if let generateLoadingSeconds {
            try await Task.sleep(nanoseconds: UInt64(generateLoadingSeconds * 1000_000_000))
        }
        
        if let verseResult {
            return verseResult
        } else {
            throw DomainError.unknown
        }
    }
}

public extension VerseUseCasePreview {
    static var preview: VerseUseCasePreview {
        VerseUseCasePreview()
    }
    
    static var dummy: GeneratedVerseInfo {
        GeneratedVerseInfo(
            verses: ["삼: 삼삼삼", "행: 행행", "시: 시시"],
            remainingLimit: 3
        )
    }
}
