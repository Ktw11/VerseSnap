//
//  VerseUseCase.swift
//  Domain
//
//  Created by 공태웅 on 4/23/25.
//

import Foundation
import UIKit

public protocol VerseUseCase: Sendable {
    func generate(image: UIImage) async throws -> GeneratedVerseInfo
    func save(verse: String, image: UIImage, hashtags: [String]) async throws
}
