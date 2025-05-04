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
    let minImageLength: CGFloat = 512
     
    override func setUp() {
        super.setUp()
        
        imageConverter = MockImageConverter()
        imageUploader = MockImageUploader()
        repository = MockDiaryRepository()
        
        sut = DiaryUseCaseImpl(
            imageConverter: imageConverter,
            imageUploader: imageUploader,
            repository: repository,
            minImageLength: minImageLength
        )
    }
    
    override func tearDown() {
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
        } catch {
            XCTFail()
        }
    }
    
    func test_save_success() async {
        // given
        let givenVerseDiary: VerseDiary = VerseDiary(
            imageURL: URL(string: "www.google.com")!.absoluteString,
            hashtags: ["tag", "tag2"],
            createdAt: 123,
            verse: "test",
            isFavorite: [true, false].randomElement()!
        )
        
        imageConverter.expectedConvertToJpegData = Data()
        imageUploader.expectedUploadImage = URL(string: "www.google.com")
        repository.expectedSaveResult = givenVerseDiary
        
        // when
        do {
            let _ = try await sut.save(verse: "test", image: UIImage(), hashtags: ["tag"])
            
            // then
            XCTAssertTrue(imageConverter.isConvertToJpegDataCalled)
            XCTAssertTrue(imageUploader.isUploadImageCalled)
            XCTAssertTrue(repository.isSaveCalled)
        } catch {
            XCTFail()
        }
    }
}
