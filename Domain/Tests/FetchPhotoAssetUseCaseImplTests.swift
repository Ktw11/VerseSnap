//
//  FetchPhotoAssetUseCaseImplTests.swift
//  DomainTests
//
//  Created by 공태웅 on 4/9/25.
//

import XCTest
import Photos
@testable import Domain

final class FetchPhotoAssetUseCaseImplTests: XCTestCase {
    
    var sut: FetchPhotoAssetUseCaseImpl!
    var authorizer: MockPhotoLibraryAuthorizer!
    var assetFetcher: MockPhotoAssetFetcher!
    
    override func setUp() {
        super.setUp()
        
        authorizer = MockPhotoLibraryAuthorizer()
        assetFetcher = MockPhotoAssetFetcher()
        
        sut = FetchPhotoAssetUseCaseImpl(
            authorizer: authorizer,
            assetFetcher: assetFetcher
        )
    }
    
    override func tearDown() {
        assetFetcher = nil
        authorizer = nil
        sut = nil
        
        super.tearDown()
    }
    
    func test_requestAuthorization_when_status_is_authorized_or_limited_then_should_not_call_requestAuthorization_return_true() async {
        // given
        let givenStatuses: [PHAuthorizationStatus] = [.authorized, .limited]
        authorizer.expectedAuthorizationStatus = givenStatuses.randomElement()
        
        // when
        let result = await sut.requestAuthorization()
        
        // then
        XCTAssertTrue(result)
        XCTAssertFalse(authorizer.isRequestAuthorizationCalled)
    }
    
    func test_requestAuthorization_when_status_is_restricted_or_denied_then_should_not_call_requestAuthorization_return_false() async {
        // given
        let givenStatuses: [PHAuthorizationStatus] = [.restricted, .denied]
        authorizer.expectedAuthorizationStatus = givenStatuses.randomElement()
        
        // when
        let result = await sut.requestAuthorization()
        
        // then
        XCTAssertFalse(result)
        XCTAssertFalse(authorizer.isRequestAuthorizationCalled)
    }
    
    func test_requestAuthorization_when_status_is_notDetermined_expected_requestAuthorization_is_authorized_or_limited_then_should_call_requestAuthorization_and_return_true() async {
        // given
        let expectedStatuses: [PHAuthorizationStatus] = [.authorized, .limited]
        authorizer.expectedRequestAuthorization = expectedStatuses.randomElement()
        authorizer.expectedAuthorizationStatus = .notDetermined
        
        // when
        let result = await sut.requestAuthorization()
        
        // then
        XCTAssertTrue(result)
        XCTAssertTrue(authorizer.isRequestAuthorizationCalled)
    }
    
    func test_requestAuthorization_when_status_is_notDetermined_expected_requestAuthorization_is_restricted_or_denied_then_should_call_requestAuthorization_and_return_false() async {
        // given
        let expectedStatuses: [PHAuthorizationStatus] = [.restricted, .denied]
        authorizer.expectedRequestAuthorization = expectedStatuses.randomElement()
        authorizer.expectedAuthorizationStatus = .notDetermined
        
        // when
        let result = await sut.requestAuthorization()
        
        // then
        XCTAssertFalse(result)
        XCTAssertTrue(authorizer.isRequestAuthorizationCalled)
    }
    
    func test_fetchAssets_when_first_then_should_call_assetFetcher_fetchPhotoAssets_return_expected_result() async {
        // given
        let expectedAssets: [DummyPHAsset] = [
            .init(identifier: "1"),
            .init(identifier: "2"),
        ]
        let fetchResult: MockPHFetchResult = .init()
        fetchResult.expectedEnumeratedAssets = expectedAssets
        assetFetcher.expectedFetchPhotoAssets = fetchResult
        
        do {
            // when
            let result = try await sut.fetchAssets(at: 0, pageSize: 3)
            
            // then
            XCTAssertEqual(result.assets.count, expectedAssets.count)
            XCTAssertEqual((result.assets[0] as? DummyPHAsset)?.identifier, "1")
            XCTAssertEqual((result.assets[1] as? DummyPHAsset)?.identifier, "2")
            XCTAssertEqual(result.nextIndex, 2)
            XCTAssertEqual(assetFetcher.fetchPhotoAssetsCallCount, 1)
        } catch {
            XCTFail()
        }
    }
    
    func test_fetchAssets_when_call_twice_then_should_call_assetFetcher_fetchPhotoAssets_once_return_expected_result() async {
        // given
        let expectedAssets: [DummyPHAsset] = [
            .init(identifier: "1"),
            .init(identifier: "2"),
        ]
        let fetchResult: MockPHFetchResult = .init()
        fetchResult.expectedEnumeratedAssets = expectedAssets
        assetFetcher.expectedFetchPhotoAssets = fetchResult
        
        do {
            // when
            let result = try await sut.fetchAssets(at: 0, pageSize: 1)
            let result2 = try await sut.fetchAssets(at: 1, pageSize: 1)
            
            // then
            XCTAssertEqual(result.assets.count, 2)
            XCTAssertEqual((result.assets[0] as? DummyPHAsset)?.identifier, "1")
            XCTAssertEqual((result.assets[1] as? DummyPHAsset)?.identifier, "2")
            XCTAssertEqual(result.nextIndex, 1)
            XCTAssertEqual(result2.nextIndex, 2)
            XCTAssertEqual(assetFetcher.fetchPhotoAssetsCallCount, 1)
        } catch {
            XCTFail()
        }
    }
    
    func test_fetchAssets_when_index_is_bigger_than_total_asset_count_then_should_not_call_enumeratedAssets_and_throw_FetchPhotoAssetError_finished() async {
        // given
        let expectedAssets: [DummyPHAsset] = [
            .init(identifier: "1"),
            .init(identifier: "2"),
        ]
        let fetchResult: MockPHFetchResult = .init()
        fetchResult.expectedEnumeratedAssets = expectedAssets
        assetFetcher.expectedFetchPhotoAssets = fetchResult
        
        do {
            // when
            _ = try await sut.fetchAssets(at: 2, pageSize: 2)
            
            XCTFail()
        } catch FetchPhotoAssetError.finished {
            // then
            XCTAssertEqual(assetFetcher.fetchPhotoAssetsCallCount, 1)
            XCTAssertFalse(fetchResult.isEnumeratedAssetsCalled)
        } catch {
            XCTFail()
        }
    }
}
