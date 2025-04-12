//
//  MockPHFetchResult.swift
//  DomainTests
//
//  Created by 공태웅 on 4/10/25.
//

import Foundation
import Photos
@testable import Domain

final class MockPHFetchResult: PHFetchResultProtocol, @unchecked Sendable {
    var isEnumeratedAssetsCalled = false
    var expectedEnumeratedAssets: [PHAsset] = []
    
    var count: Int {
        expectedEnumeratedAssets.count
    }
    
    func enumeratedAssets(at indexes: IndexSet, options: NSEnumerationOptions) async -> [PHAsset] {
        isEnumeratedAssetsCalled = true
        return expectedEnumeratedAssets
    }
}
