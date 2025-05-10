//
//  DiaryUseCaseImplTests.swift
//  Domain
//
//  Created by 공태웅 on 5/4/25.
//

import XCTest
import UIKit
@testable import Domain

final class DiaryUseCaseImplTests: XCTestCase {
    
    var sut: DiaryUseCaseImpl!
    var imageConverter: MockImageConverter!
    var imageUploader: MockImageUploader!
    var repository: MockDiaryRepository!
    var diaryEventSender: MockDiaryEventSender!
    let minImageLength: CGFloat = 512
     
    override func setUp() {
        super.setUp()
        
        imageConverter = MockImageConverter()
        imageUploader = MockImageUploader()
        repository = MockDiaryRepository()
        diaryEventSender = MockDiaryEventSender()
        
        sut = DiaryUseCaseImpl(
            imageConverter: imageConverter,
            imageUploader: imageUploader,
            repository: repository,
            diaryEventSender: diaryEventSender,
            minImageLength: minImageLength,
            calendar: Calendar(identifier: .gregorian)
        )
    }
    
    override func tearDown() {
        diaryEventSender = nil
        repository = nil
        imageConverter = nil
        imageUploader = nil
        sut = nil
        
        super.tearDown()
    }
    
    func test_save_when_image_convert_fails_then_throw_DomainError_failedToConvertImageToData() async {
        // given
        imageConverter.expectedConvertToJpegData = nil
        
        // when
        do {
            _ = try await sut.save(verse: "test", image: UIImage(), hashtags: ["tag"])
            XCTFail()
        } catch DomainError.failedToConvertImageToData {
            // then
            XCTAssertTrue(imageConverter.isConvertToJpegDataCalled)
            XCTAssertEqual(imageConverter.requestedMinLength, minImageLength)
            XCTAssertEqual(imageConverter.requestedOutputScale, 1.0)
            XCTAssertEqual(imageConverter.requestedMaxKB, 900 * 1024)
            XCTAssertFalse(diaryEventSender.isSendCalled)
        } catch {
            XCTFail()
        }
    }
    
    func test_save_when_image_convert_success_and_image_upload_fails_throw_DomainError_failedToUploadImage() async {
        // given
        imageConverter.expectedConvertToJpegData = Data()
        imageUploader.expectedUploadImage = nil
        
        // when
        do {
            _ = try await sut.save(verse: "test", image: UIImage(), hashtags: ["tag"])
            XCTFail()
        } catch DomainError.failedToUploadImage {
            // then
            XCTAssertTrue(imageUploader.isUploadImageCalled)
            XCTAssertFalse(diaryEventSender.isSendCalled)
        } catch {
            XCTFail()
        }
    }
    
    func test_save_when_image_convert_success_and_image_upload_success_and_repository_fails_then_throw_error() async {
        // given
        let givenVerse: String = "test"
        let givenImageURL: URL = URL(string: "www.google.com")!
        let givenHashtags: [String] = ["tag", "tag2"]
        
        imageConverter.expectedConvertToJpegData = Data()
        imageUploader.expectedUploadImage = givenImageURL
        repository.expectedSaveError = TestError.common
        
        // when
        do {
            _ = try await sut.save(verse: givenVerse, image: UIImage(), hashtags: givenHashtags)
            XCTFail()
        } catch TestError.common {
            // then
            XCTAssertTrue(repository.isSaveCalled)
            XCTAssertEqual(givenVerse, repository.requestedSaveVerse)
            XCTAssertEqual(givenImageURL.absoluteString, repository.requestedSaveImageURL)
            XCTAssertEqual(givenHashtags, repository.requestedSaveHashtags)
            XCTAssertFalse(diaryEventSender.isSendCalled)
        } catch {
            XCTFail()
        }
    }
    
    func test_save_success() async {
        // given
        repository.expectedSave = VerseDiary(
            id: "id",
            imageURL: "url",
            hashtags: [],
            createdAt: 123,
            verse: "verse",
            isFavorite: true
        )
        imageConverter.expectedConvertToJpegData = Data()
        imageUploader.expectedUploadImage = URL(string: "www.google.com")
        
        // when
        do {
            let _ = try await sut.save(verse: "test", image: UIImage(), hashtags: ["tag"])
            
            // then
            XCTAssertTrue(imageConverter.isConvertToJpegDataCalled)
            XCTAssertTrue(imageUploader.isUploadImageCalled)
            XCTAssertTrue(repository.isSaveCalled)
            XCTAssertTrue(diaryEventSender.isSendCalled)
        } catch {
            XCTFail()
        }
    }
    
    func test_fetchDiaries_when_year_month_is_valid_repository_fails_then_throw_error() async {
        // given
        repository.expectedFetchDiariesError = TestError.common

        // when
        do {
            _ = try await sut.fetchDiaries(
                year: 1010,
                month: 12,
                after: DiaryCursor(size: 10, lastCreatedAt: 200)
            )
            XCTFail()
        } catch TestError.common {
            // then
            XCTAssertTrue(repository.isFetchDiariesCalled)
        } catch {
            XCTFail()
        }
    }
    
    func test_fetchDiaries_when_year_month_is_valid_repository_returns_data_then_return_data() async {
        // given
        let expectedResult = DiaryFetchResult(
            diaries: [
                VerseDiary(id: "1", imageURL: "url1", hashtags: ["tag"], createdAt: 100, verse: "v1", isFavorite: false),
                VerseDiary(id: "2", imageURL: "url2", hashtags: ["tag2"], createdAt: 90, verse: "v2", isFavorite: true)
            ],
            isLastPage: true
        )
        repository.expectedFetchDiaries = expectedResult
        
        // when
        let result = try? await sut.fetchDiaries(
            year: 2000,
            month: 2,
            after: DiaryCursor(size: 10, lastCreatedAt: 200)
        )
        
        // then
        XCTAssertEqual(result, expectedResult)
        XCTAssertTrue(repository.isFetchDiariesCalled)
    }
    
    func test_fetchDiariesAll_when_repository_fails_then_throw_error() async {
        // given
        repository.expectedFetchDiariesAllError = TestError.common
        
        // when
        do {
            _ = try await sut.fetchDiariesAll(after: DiaryCursor(size: 10, lastCreatedAt: 200))
            XCTFail()
        } catch {
            // then
            XCTAssertTrue(repository.isFetchDiariesAllCalled)
        }
    }
    
    func test_fetchDiariesAll_when_repository_success_then_return_data() async {
        // given
        let givenResult = DiaryFetchResult(
            diaries: [
                VerseDiary(id: "1", imageURL: "url1", hashtags: ["tag"], createdAt: 100, verse: "v1", isFavorite: false),
                VerseDiary(id: "2", imageURL: "url2", hashtags: ["tag2"], createdAt: 90, verse: "v2", isFavorite: true)
            ],
            isLastPage: true
        )
        repository.expectedFetchDiariesAll = givenResult
        
        do {
            // when
            let result = try await sut.fetchDiariesAll(after: DiaryCursor(size: 10, lastCreatedAt: 200))
            
            // then
            XCTAssertEqual(givenResult, result)
            XCTAssertTrue(repository.isFetchDiariesAllCalled)
        } catch {
            XCTFail()
        }
    }
    
    func test_updateFavorite_when_repository_fails_then_throw_error() async {
        // given
        let givenValue: Bool = [true, false].randomElement()!
        let givenId: String = "id"
        
        repository.expectedUpdateFavoriteError = TestError.common
        
        // when
        do {
            _ = try await sut.updateFavorite(to: givenValue, id: givenId)
            XCTFail()
        } catch {
            // then
            XCTAssertTrue(repository.isUpdateFavoriteCalled)
            XCTAssertEqual(repository.requestedUpdateFavoriteTo, givenValue)
            XCTAssertEqual(repository.requestedUpdateFavoriteId, givenId)
        }
    }
    
    func test_updateFavorite_when_repository_success_then_success() async {
        // given
        let givenValue: Bool = [true, false].randomElement()!
        let givenId: String = "id2"
        
        repository.expectedUpdateFavoriteError = nil
        
        // when
        do {
            _ = try await sut.updateFavorite(to: givenValue, id: givenId)
            
            // then
            XCTAssertTrue(repository.isUpdateFavoriteCalled)
            XCTAssertEqual(repository.requestedUpdateFavoriteTo, givenValue)
            XCTAssertEqual(repository.requestedUpdateFavoriteId, givenId)
        } catch {
            XCTFail()
        }
    }
}
