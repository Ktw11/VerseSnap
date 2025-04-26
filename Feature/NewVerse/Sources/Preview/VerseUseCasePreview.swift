//
//  VerseUseCasePreview.swift
//  NewDiary
//
//  Created by 공태웅 on 4/26/25.
//

import Foundation
import UIKit
import Domain

final class VerseUseCasePreview: VerseUseCase, @unchecked Sendable {
    
    var expectedVerseResult: VerseResult?
    
    func generate(image: UIImage) async throws -> VerseResult {
        if let expectedVerseResult {
            expectedVerseResult
        } else {
            throw VerseError.unknown
        }
    }
}
