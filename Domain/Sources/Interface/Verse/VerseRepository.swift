//
//  VerseRepository.swift
//  Domain
//
//  Created by 공태웅 on 5/4/25.
//

import Foundation

public protocol VerseRepository: Sendable {
    func generate(imageData: Data, isKorean: Bool) async throws -> GeneratedVerseInfo
}
