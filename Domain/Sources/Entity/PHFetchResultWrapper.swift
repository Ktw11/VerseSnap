//
//  PHFetchResultWrapper.swift
//  DomainTests
//
//  Created by 공태웅 on 4/10/25.
//

import Foundation
import Photos

public struct PHFetchResultWrapper: PHFetchResultProtocol {
    private let fetchResult: PHFetchResult<PHAsset>
    
    public var count: Int {
        return fetchResult.count
    }
    
    public init(fetchResult: PHFetchResult<PHAsset>) {
        self.fetchResult = fetchResult
    }
    
    public func enumeratedAssets(at indexes: IndexSet, options: NSEnumerationOptions) async -> [PHAsset] {
        await withCheckedContinuation { [fetchResult] continuation in
            var assets: [PHAsset] = []
            
            fetchResult.enumerateObjects(at: indexes, options: options) { asset, _, _ in
                assets.append(asset)
            }
            
            continuation.resume(returning: assets)
        }
    }
}
