//
//  VerseUseCaseImplTests.swift
//  Domain
//
//  Created by 공태웅 on 4/26/25.
//

import XCTest
import UIKit
@testable import Domain

final class VerseUseCaseImplTests: XCTestCase {
    
    var sut: VerseUseCaseImpl!
    var locale: MockLocale!
    var imageConverter: MockImageConverter!
    var imageUploader: MockImageUploader!
    var repository: MockVerseRepository!
     
    override func setUp() {
        super.setUp()
        
        locale = MockLocale()
        imageConverter = MockImageConverter()
        imageUploader = MockImageUploader()
        repository = MockVerseRepository()
        
        sut = VerseUseCaseImpl(
            locale: locale,
            imageConverter: imageConverter,
            imageUploader: imageUploader,
            repository: repository
        )
    }
    
    override func tearDown() {
        repository = nil
        imageConverter = nil
        imageUploader = nil
        locale = nil
        sut = nil
        
        super.tearDown()
    }
    
    func test_generate_then_should_request_given_image_and_minLength() async {
        // given
        imageConverter.expectedConvertToJpegData = Data()
        
        // when
        _ = try? await sut.generate(image: UIImage())
        
        // then
        XCTAssertTrue(imageConverter.isConvertToJpegDataCalled)
        XCTAssertEqual(imageConverter.requestedMinLength, VerseUseCaseImpl.Constants.minLength)
        XCTAssertEqual(imageConverter.requestedOutputScale, 1.0)
        XCTAssertEqual(imageConverter.requestedMaxKB, 200 * 1024)
    }
    
    func test_generate_when_imageConverter_retuns_nil_then_throw_DomainError_failedToConvertImageToData() async {
        // given
        imageConverter.expectedConvertToJpegData = nil
        
        // when
        do {
            _ = try await sut.generate(image: UIImage())
            XCTFail()
        } catch DomainError.failedToConvertImageToData {
            // then
            XCTAssert(true)
        } catch {
            XCTFail()
        }
    }

    func test_generate_when_image_convert_success_image_upload_success_locale_isLanguageKorean_true_repository_success_then_return_VerseResult() async {
        // given
        let givenVerseInfo: GeneratedVerseInfo = .init(
            verse: "asdasd",
            remainingLimit: 153
        )
        repository.expectedGenerateInfo = givenVerseInfo
        imageConverter.expectedConvertToJpegData = Data()
        locale.isLanguageKorean = true
        
        // when
        do {
            let result = try await sut.generate(image: UIImage())
            
            // then
            XCTAssertEqual(result, givenVerseInfo)
            XCTAssertTrue(repository.isGenerateCalled)
            XCTAssertEqual(true, repository.requestedGenerateIsKorean)
        } catch {
            XCTFail()
        }
    }
    
    func test_generate_when_image_convert_success_image_upload_success_with_locale_isLanguageKorean_false_repository_success_then_return_VerseResult() async {
        // given
        let givenVerseInfo: GeneratedVerseInfo = .init(
            verse: "asdasd",
            remainingLimit: 153
        )
        repository.expectedGenerateInfo = givenVerseInfo
        imageConverter.expectedConvertToJpegData = Data()
        locale.isLanguageKorean = false
        
        // when
        do {
            let result = try await sut.generate(image: UIImage())
            
            // then
            XCTAssertEqual(result, givenVerseInfo)
            XCTAssertTrue(repository.isGenerateCalled)
            XCTAssertEqual(false, repository.requestedGenerateIsKorean)
        } catch {
            XCTFail()
        }
    }
    
    func test_generate_when_image_convert_success_image_upload_success_with_repository_fail_then_throw_error() async {
        // given
        let givenError: Error = TestError.common
        repository.expectedGenerateError = givenError
        imageConverter.expectedConvertToJpegData = Data()
        
        // when
        do {
            _ = try await sut.generate(image: UIImage())
            XCTFail()
        } catch TestError.common {
            // then
            XCTAssertTrue(true)
            XCTAssertTrue(repository.isGenerateCalled)
            XCTAssertEqual(false, repository.requestedGenerateIsKorean)
        } catch {
            XCTFail()
        }
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
            XCTAssertEqual(imageConverter.requestedMinLength, VerseUseCaseImpl.Constants.minLength)
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
