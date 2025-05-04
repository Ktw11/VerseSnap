//
//  DiaryUseCasePreview.swift
//  PreviewSupport
//
//  Created by 공태웅 on 5/4/25.
//

import Foundation
import UIKit
import Domain

public final class DiaryUseCasePreview: DiaryUseCase, @unchecked Sendable {

    // MARK: Properties

    public var saveLoadingSeconds: Int?
    
    // MARK: Methods
    
    public func save(verse: String, image: UIImage, hashtags: [String]) async throws {
        if let saveLoadingSeconds {
            try await Task.sleep(nanoseconds: UInt64(saveLoadingSeconds * 1000_000_000))
        }
    }
}

public extension DiaryUseCasePreview {
    static var preview: DiaryUseCasePreview {
        DiaryUseCasePreview()
    }
}
