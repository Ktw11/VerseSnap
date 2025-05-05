//
//  VerseUseCaseImpl.swift
//  Domain
//
//  Created by 공태웅 on 4/24/25.
//

import Foundation
import UIKit

public final class VerseUseCaseImpl: VerseUseCase {

    // MARK: Lifecycle
    
    public init(
        locale: LocaleGettable,
        imageConverter: ImageConvertable,
        repository: VerseRepository,
        minImageLength: CGFloat
    ) {
        self.locale = locale
        self.imageConverter = imageConverter
        self.repository = repository
        self.minImageLength = minImageLength
    }
    
    // MARK: Properties
    
    private let locale: LocaleGettable
    private let imageConverter: ImageConvertable
    private let repository: VerseRepository
    private let minImageLength: CGFloat
    
    // MARK: Methods
    
    public func generate(image: UIImage) async throws -> GeneratedVerseInfo {
        guard let imageData = imageConverter.convertToJpegData(image, minLength: minImageLength, maxKB: 200 * 1024) else {
            throw DomainError.failedToConvertImageToData
        }

        try Task.checkCancellation()
        
        return try await repository.generate(
            imageData: imageData,
            isKorean: locale.isLanguageKorean
        )
    }
}

private extension ImageConvertable {
    func convertToJpegData(_ image: UIImage, minLength: CGFloat, maxKB: Int) -> Data? {
        convertToJpegData(
            image,
            minLength: minLength,
            outputScale: 1.0,
            maxKB: maxKB
        )
    }
}
