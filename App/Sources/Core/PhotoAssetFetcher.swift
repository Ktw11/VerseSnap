//
//  PhotoAssetFetcher.swift
//  App
//
//  Created by 공태웅 on 4/12/25.
//

import Foundation
import Photos
import Domain

struct PhotoAssetFetcher: PhotoAssetFetchable {

    // MARK: Methods
    
    func fetchPhotoAssets(with type: PHAssetMediaType, options: PHFetchOptions) -> PHFetchResultProtocol {
        let result = PHAsset.fetchAssets(with: type, options: options)
        return PHFetchResultWrapper(fetchResult: result)
    }
}
