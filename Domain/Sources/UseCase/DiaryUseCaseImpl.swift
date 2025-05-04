//
//  DiaryUseCaseImpl.swift
//  Domain
//
//  Created by 공태웅 on 5/4/25.
//

import Foundation
import UIKit

public final class DiaryUseCaseImpl: DiaryUseCase {

    // MARK: Lifecycle
    
    public init(
        imageConverter: ImageConvertable,
        imageUploader: ImageUploadable,
        repository: DiaryRepository,
        minImageLength: CGFloat
    ) {
        self.imageConverter = imageConverter
        self.imageUploader = imageUploader
        self.repository = repository
        self.minImageLength = minImageLength
    }
    
    // MARK: Properties
    
    private let imageConverter: ImageConvertable
    private let imageUploader: ImageUploadable
    private let repository: DiaryRepository
    private let minImageLength: CGFloat
    
    // MARK: Methods

    public func save(verse: String, image: UIImage, hashtags: [String]) async throws {
        guard let imageData = imageConverter.convertToJpegData(image, minLength: minImageLength, maxKB: 900 * 1024) else {
            throw DomainError.failedToConvertImageToData
        }
        guard let imageURL = try? await imageUploader.uploadImage(imageData: imageData, pathRoot: "images") else {
            throw DomainError.failedToUploadImage
        }

        _ = try await repository.save(
            verse: verse,
            imageURL: imageURL.absoluteString,
            hashtags: hashtags
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
