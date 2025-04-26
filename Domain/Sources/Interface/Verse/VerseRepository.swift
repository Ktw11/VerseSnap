//
//  VerseRepository.swift
//  Domain
//
//  Created by 공태웅 on 4/24/25.
//

import Foundation

public protocol VerseRepository: Sendable {
    func generateVerse(encodedImage: String, isKorean: Bool) async throws -> VerseResult
}
