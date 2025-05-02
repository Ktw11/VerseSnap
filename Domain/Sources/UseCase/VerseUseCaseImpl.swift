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
        imageUploader: ImageUploadable,
        repository: VerseRepository
    ) {
        self.locale = locale
        self.imageConverter = imageConverter
        self.imageUploader = imageUploader
        self.repository = repository
    }
    
    // MARK: Definitions
    
    enum Constants {
        static let minLength: CGFloat = 512
    }
    
    // MARK: Properties
    
    private let locale: LocaleGettable
    private let imageConverter: ImageConvertable
    private let imageUploader: ImageUploadable
    private let repository: VerseRepository
    
    // MARK: Methods
    
    public func generate(image: UIImage, hashtags: [String]) async throws -> GeneratedVerseInfo {
        guard let imageData = imageConverter.convertToJpegData(image, minLength: Constants.minLength) else { throw DomainError.failedToConvertImageToData }
        guard let imageURL = try? await imageUploader.uploadImage(imageData: imageData, pathRoot: "images") else {
            throw DomainError.failedToUploadImage
        }

        return try await repository.generateVerse(
            imageURLString: imageURL.absoluteString,
            isKorean: locale.isLanguageKorean,
            hashtags: hashtags
        )
    }
}

private extension ImageConvertable {
    func convertToJpegData(_ image: UIImage, minLength: CGFloat) -> Data? {
        convertToJpegData(
            image,
            minLength: minLength,
            outputScale: 1.0,
            maxKB: 900 * 1024
        )
    }
}
