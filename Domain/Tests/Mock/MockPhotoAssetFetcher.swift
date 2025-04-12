//
//  MockPhotoAssetFetcher.swift
//  DomainTests
//
//  Created by 공태웅 on 4/10/25.
//

import Foundation
import Photos
@testable import Domain

final class MockPhotoAssetFetcher: PhotoAssetFetchable, @unchecked Sendable {
    var fetchPhotoAssetsCallCount: Int = 0
    var expectedFetchPhotoAssets: PHFetchResultProtocol?
    
    func fetchPhotoAssets(with type: PHAssetMediaType, options: PHFetchOptions) -> any PHFetchResultProtocol {
        fetchPhotoAssetsCallCount += 1
        return expectedFetchPhotoAssets!
    }
}
