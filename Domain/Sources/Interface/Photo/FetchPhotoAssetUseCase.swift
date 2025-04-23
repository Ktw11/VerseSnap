//
//  FetchPhotoAssetUseCase.swift
//  Domain
//
//  Created by 공태웅 on 4/9/25.
//

import Foundation

public protocol FetchPhotoAssetUseCase: Sendable {
    func requestAuthorization() async -> Bool
    func fetchAssets(at index: Int, pageSize: Int) async throws -> PhotoAssetPageResult
}
