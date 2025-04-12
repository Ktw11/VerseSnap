//
//  PhotoAssetPageResult.swift
//  Domain
//
//  Created by 공태웅 on 4/9/25.
//

import Foundation
import Photos

public struct PhotoAssetPageResult: Sendable {
    public let assets: [PHAsset]
    public let nextIndex: Int
    public let isFinished: Bool
}
