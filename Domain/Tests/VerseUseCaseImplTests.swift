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
    var repository: MockVerseRepository!
    let minImageLength: CGFloat = 512
     
    override func setUp() {
        super.setUp()
        
        locale = MockLocale()
        imageConverter = MockImageConverter()
        repository = MockVerseRepository()
        
        sut = VerseUseCaseImpl(
            locale: locale,
            imageConverter: imageConverter,
            repository: repository,
            minImageLength: minImageLength
        )
    }
    
    override func tearDown() {
        repository = nil
        imageConverter = nil
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
        XCTAssertEqual(imageConverter.requestedMinLength, minImageLength)
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
            verses: ["asdasd"],
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
            verses: ["asdasd"],
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
}
