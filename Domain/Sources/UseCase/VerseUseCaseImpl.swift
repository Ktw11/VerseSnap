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
        imageResizeProvider: ImageResizable,
        repository: VerseRepository
    ) {
        self.locale = locale
        self.imageResizeProvider = imageResizeProvider
        self.repository = repository
    }
    
    // MARK: Definitions
    
    enum Constants {
        static let minLength: CGFloat = 512
    }
    
    // MARK: Properties
    
    private let locale: LocaleGettable
    private let imageResizeProvider: ImageResizable
    private let repository: VerseRepository
    
    // MARK: Methods
    
    public func generate(image: UIImage) async throws -> VerseResult {
        guard let resizedImage = imageResizeProvider.resizeImage(image, minLength: Constants.minLength) else { throw VerseError.failedToResizeImage }
        guard let imageData = resizedImage.pngData() else { throw VerseError.failedToConvertImageToData }
        
        let encodedImage: String = imageData.base64EncodedString()
        return try await repository.generateVerse(encodedImage: encodedImage, isKorean: locale.isLanguageKorean)
    }
}

private extension ImageResizable {
    func resizeImage(_ image: UIImage, minLength: CGFloat) -> UIImage? {
        resizeImage(image, minLength: minLength, outputScale: 1.0)
    }
}
