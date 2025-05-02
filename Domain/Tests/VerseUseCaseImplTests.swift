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
        _ = try? await sut.generate(image: UIImage(), hashtags: [])
        
        // then
        XCTAssertTrue(imageConverter.isConvertToJpegDataCalled)
        XCTAssertEqual(imageConverter.requestedMinLength, VerseUseCaseImpl.Constants.minLength)
        XCTAssertEqual(imageConverter.requestedOutputScale, 1.0)
        XCTAssertEqual(imageConverter.requestedMaxKB, 900 * 1024)
    }
    
    func test_generate_when_imageConverter_retuns_nil_then_throw_DomainError_failedToConvertImageToData() async {
        // given
        imageConverter.expectedConvertToJpegData = nil
        
        // when
        do {
            _ = try await sut.generate(image: UIImage(), hashtags: [])
            XCTFail()
        } catch DomainError.failedToConvertImageToData {
            // then
            XCTAssert(true)
        } catch {
            XCTFail()
        }
    }
    
    @MainActor
    func test_generate_when_image_convert_success_image_upload_fail_then_throw_DomainError_failedToUploadImage() async {
        // given
        imageConverter.expectedConvertToJpegData = Data()
        imageUploader.expectedUploadImageError = TestError.common
        
        // when
        do {
            _ = try await sut.generate(image: UIImage(), hashtags: [])
            XCTFail()
        } catch DomainError.failedToUploadImage {
            // then
            XCTAssert(true)
        } catch {
            XCTFail()
        }
    }
    
    @MainActor
    func test_generate_when_image_convert_success_image_upload_success_locale_isLanguageKorean_true_repository_success_then_return_VerseResult() async {
        // given
        let givenVerseInfo: GeneratedVerseInfo = .init(
            imageURL: "image",
            hashtags: ["a", "c"],
            createdAt: 14871,
            verse: "asdasd",
            isFavorite: true,
            remainingLimit: 153
        )
        let givenHashtags: [String] = ["a", "b", "c"]
        repository.expectedGenerateVerseInfo = givenVerseInfo
        imageConverter.expectedConvertToJpegData = Data()
        imageUploader.expectedUploadImage = URL(string: "www.google.com")
        locale.isLanguageKorean = true
        
        // when
        do {
            let result = try await sut.generate(image: UIImage(), hashtags: givenHashtags)
            
            // then
            XCTAssertEqual(result, givenVerseInfo)
            XCTAssertTrue(repository.isGenerateVerseCalled)
            XCTAssertEqual(true, repository.requestedIsKorean)
            XCTAssertEqual(givenHashtags, repository.requestedHashtags)
        } catch {
            XCTFail()
        }
    }
    
    @MainActor
    func test_generate_when_image_convert_success_image_upload_success_with_locale_isLanguageKorean_false_repository_success_then_return_VerseResult() async {
        // given
        let givenVerseInfo: GeneratedVerseInfo = .init(
            imageURL: "image",
            hashtags: ["a", "c"],
            createdAt: 14871,
            verse: "asdasd",
            isFavorite: true,
            remainingLimit: 153
        )
        let givenHashtags: [String] = ["1", "2", "3"]
        repository.expectedGenerateVerseInfo = givenVerseInfo
        imageConverter.expectedConvertToJpegData = Data()
        imageUploader.expectedUploadImage = URL(string: "www.google.com")
        locale.isLanguageKorean = false
        
        // when
        do {
            let result = try await sut.generate(image: UIImage(), hashtags: givenHashtags)
            
            // then
            XCTAssertEqual(result, givenVerseInfo)
            XCTAssertTrue(repository.isGenerateVerseCalled)
            XCTAssertEqual(false, repository.requestedIsKorean)
            XCTAssertEqual(givenHashtags, repository.requestedHashtags)
        } catch {
            XCTFail()
        }
    }
    
    @MainActor
    func test_generate_when_image_convert_success_image_upload_success_with_repository_fail_then_throw_error() async {
        // given
        let givenError: Error = TestError.common
        repository.expectedGenerateVerseError = givenError
        imageConverter.expectedConvertToJpegData = Data()
        imageUploader.expectedUploadImage = URL(string: "www.google.com")
        
        // when
        do {
            _ = try await sut.generate(image: UIImage(), hashtags: [])
            XCTFail()
        } catch TestError.common {
            // then
            XCTAssertTrue(true)
            XCTAssertTrue(repository.isGenerateVerseCalled)
            XCTAssertEqual(false, repository.requestedIsKorean)
        } catch {
            XCTFail()
        }
    }
}
