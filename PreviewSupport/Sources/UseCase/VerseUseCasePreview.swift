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
    public var sleepingSecond: Int?
    
    // MARK: Methods
    
    public func generate(image: UIImage) async throws -> GeneratedVerseInfo {
        if let sleepingSecond {
            try await Task.sleep(nanoseconds: UInt64(sleepingSecond * 1000_000_000))
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
            verse: "삼: 삼삼삼\n행: 행행행\n시: 시시시",
            remainingLimit: 3
        )
    }
}
