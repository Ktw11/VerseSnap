//
//  DiaryUseCase.swift
//  Domain
//
//  Created by 공태웅 on 5/4/25.
//

import Foundation
import UIKit

public protocol DiaryUseCase: Sendable {
    func save(verse: String, image: UIImage, hashtags: [String]) async throws
    func fetchDiaries(year: Int, month: Int, after cursor: DiaryCursor) async throws -> DiaryFetchResult
    func fetchDiariesAll(after cursor: DiaryCursor) async throws -> DiaryFetchResult
}
