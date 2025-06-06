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
        diaryEventSender: DiaryEventSender,
        minImageLength: CGFloat,
        calendar: Calendar
    ) {
        self.imageConverter = imageConverter
        self.imageUploader = imageUploader
        self.repository = repository
        self.diaryEventSender = diaryEventSender
        self.minImageLength = minImageLength
        self.calendar = calendar
    }
    
    // MARK: Properties
    
    private let imageConverter: ImageConvertable
    private let imageUploader: ImageUploadable
    private let repository: DiaryRepository
    private let diaryEventSender: DiaryEventSender
    private let minImageLength: CGFloat
    private let calendar: Calendar
    
    // MARK: Methods

    public func save(verses: [String], image: UIImage, hashtags: [String]) async throws {
        guard let imageData = imageConverter.convertToJpegData(image, minLength: minImageLength, maxKB: 900 * 1024) else {
            throw DomainError.failedToConvertImageToData
        }
        guard let imageURL = try? await imageUploader.uploadImage(imageData: imageData, pathRoot: "images") else {
            throw DomainError.failedToUploadImage
        }

        let result = try await repository.save(
            verses: verses,
            imageURL: imageURL.absoluteString,
            hashtags: hashtags
        )
        
        diaryEventSender.send(.created(result))
    }
    
    public func fetchDiaries(year: Int, month: Int, after cursor: DiaryCursor) async throws -> DiaryFetchResult {
        let dateComponents: DateComponents = .init(year: year, month: month, day: 1)
        guard let startDate = calendar.date(from: dateComponents) else { throw DiaryUseCaseError.failedToConvertDate }
        guard let endDate = calendar.date(byAdding: .month, value: 1, to: startDate) else { throw DiaryUseCaseError.failedToConvertDate }

        let startTimestamp = startDate.timeIntervalSince1970
        let endTimestamp = endDate.timeIntervalSince1970
        
        try Task.checkCancellation()
        
        return try await repository.fetchDiaries(
            startTimestamp: startTimestamp,
            endTimestamp: endTimestamp,
            after: cursor
        )
    }
    
    public func fetchDiariesAll(after cursor: DiaryCursor) async throws -> DiaryFetchResult {
        try Task.checkCancellation()
        return try await repository.fetchDiariesAll(after: cursor)
    }
    
    public func updateFavorite(to isFavorite: Bool, id: String) async throws {
        try Task.checkCancellation()
        return try await repository.updateFavorite(to: isFavorite, id: id)
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
