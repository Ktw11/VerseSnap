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
    var imageResizeProvider: MockImageResizeProvider!
    var repository: MockVerseRepository!
     
    override func setUp() {
        super.setUp()
        
        locale = MockLocale()
        imageResizeProvider = MockImageResizeProvider()
        repository = MockVerseRepository()
        
        sut = VerseUseCaseImpl(
            locale: locale,
            imageResizeProvider: imageResizeProvider,
            repository: repository
        )
    }
    
    override func tearDown() {
        repository = nil
        imageResizeProvider = nil
        locale = nil
        sut = nil
        
        super.tearDown()
    }
    
    func test_generate_then_should_request_given_image_and_minLength() async {
        // given
        imageResizeProvider.expectedResizeImage = UIImage()
        
        // when
        _ = try? await sut.generate(image: UIImage())
        
        // then
        XCTAssertTrue(imageResizeProvider.isResizeImageCalled)
        XCTAssertEqual(imageResizeProvider.requestedMinLength, VerseUseCaseImpl.Constants.minLength)
        XCTAssertEqual(imageResizeProvider.requestedOutputScale, 1.0)
    }
    
    func test_generate_when_image_resize_retuns_nil_then_throw_VerseError_failedToResizeImage() async {
        // given
        imageResizeProvider.expectedResizeImage = nil
        
        // when
        do {
            _ = try await sut.generate(image: UIImage())
            XCTFail()
        } catch VerseError.failedToResizeImage {
            // then
            XCTAssert(true)
        } catch {
            XCTFail()
        }
    }
    
    func test_generate_when_image_resize_success_with_invalid_data_then_throw_VerseError_failedToConvertImageToData() async {
        // given
        let givenVerseResult: VerseResult = .init(verse: "verse", remainingLimit: 2)
        repository.expectedGenerateVerse = givenVerseResult
        imageResizeProvider.expectedResizeImage = UIImage()
        locale.isLanguageKorean = true
        
        // when
        do {
            _ = try await sut.generate(image: UIImage())
            XCTFail()
        } catch VerseError.failedToConvertImageToData {
            // then
            XCTAssertTrue(true)
            XCTAssertTrue(imageResizeProvider.isResizeImageCalled)
            XCTAssertFalse(repository.isGenerateVerseCalled)
        } catch {
            XCTFail()
        }
    }
    
    @MainActor
    func test_generate_when_image_resize_success_with_valid_data_locale_isLanguageKorean_true_repository_success_then_return_VerseResult() async {
        // given
        let givenVerseResult: VerseResult = .init(verse: "verse", remainingLimit: 2)
        repository.expectedGenerateVerse = givenVerseResult
        imageResizeProvider.expectedResizeImage = makeTestImage()
        locale.isLanguageKorean = true
        
        // when
        do {
            let result = try await sut.generate(image: UIImage())
            
            // then
            XCTAssertEqual(result, givenVerseResult)
            XCTAssertTrue(repository.isGenerateVerseCalled)
            XCTAssertEqual(true, repository.requestedIsKorean)
        } catch {
            XCTFail()
        }
    }
    
    @MainActor
    func test_generate_when_image_resize_success_with_valid_data_locale_isLanguageKorean_false_repository_success_then_return_VerseResult() async {
        // given
        let givenVerseResult: VerseResult = .init(verse: "verse", remainingLimit: 2)
        repository.expectedGenerateVerse = givenVerseResult
        imageResizeProvider.expectedResizeImage = makeTestImage()
        locale.isLanguageKorean = false
        
        // when
        do {
            let result = try await sut.generate(image: UIImage())
            
            // then
            XCTAssertEqual(result, givenVerseResult)
            XCTAssertTrue(repository.isGenerateVerseCalled)
            XCTAssertEqual(false, repository.requestedIsKorean)
        } catch {
            XCTFail()
        }
    }
    
    @MainActor
    func test_generate_when_image_resize_success_with_valid_data_repository_fail_then_throw_error() async {
        // given
        let givenError: Error = TestError.common
        repository.expectedGenerateVerseError = givenError
        imageResizeProvider.expectedResizeImage = makeTestImage()
        
        // when
        do {
            _ = try await sut.generate(image: UIImage())
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

private extension VerseUseCaseImplTests {
    @MainActor
    func makeTestImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 1, height: 1))
        return renderer.image { context in
            UIColor.red.setFill()
            context.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        }
    }
}
