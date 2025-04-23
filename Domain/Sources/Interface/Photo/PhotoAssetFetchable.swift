//
//  PhotoAssetFetchable.swift
//  DomainTests
//
//  Created by 공태웅 on 4/10/25.
//

import Foundation
import Photos

public protocol PhotoAssetFetchable: Sendable {
    func fetchPhotoAssets(with type: PHAssetMediaType, options: PHFetchOptions) -> PHFetchResultProtocol
}
