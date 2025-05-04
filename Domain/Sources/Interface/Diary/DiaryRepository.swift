//
//  DiaryRepository.swift
//  Domain
//
//  Created by 공태웅 on 5/4/25.
//

import Foundation

public protocol DiaryRepository: Sendable {
    func save(verse: String, imageURL: String, hashtags: [String]) async throws
}
