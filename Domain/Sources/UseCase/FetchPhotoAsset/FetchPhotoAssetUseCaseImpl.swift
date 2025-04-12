//
//  FetchPhotoAssetUseCaseImpl.swift
//  Domain
//
//  Created by 공태웅 on 4/9/25.
//

import Foundation
import Photos

public actor FetchPhotoAssetUseCaseImpl: FetchPhotoAssetUseCase {
    
    // MARK: Lifecycle
    
    public init(
        authorizer: PhotoLibraryAuthorizable,
        assetFetcher: PhotoAssetFetchable
    ) {
        self.authorizer = authorizer
        self.assetFetcher = assetFetcher
    }
    
    // MARK: Properties
    
    private let authorizer: PhotoLibraryAuthorizable
    private let assetFetcher: PhotoAssetFetchable
    private var fetchResult: PHFetchResultProtocol?
    private let accessLevel: PHAccessLevel = .readWrite
    
    // MARK: Methods
    
    public func requestAuthorization() async -> Bool {
        let currentStatus = authorizer.authorizationStatus(for: accessLevel)
        return await handleAuthStatus(currentStatus)
    }
    
    public func fetchAssets(at index: Int, pageSize: Int) async throws -> PhotoAssetPageResult {
        try Task.checkCancellation()
        
        if let fetchResult {
            return try await fetchAssets(with: fetchResult, index: index, size: pageSize)
        } else {
            let options = PHFetchOptions()
            options.includeHiddenAssets = false
            options.includeAssetSourceTypes = [.typeUserLibrary]
            options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            
            let result = assetFetcher.fetchPhotoAssets(with: .image, options: options)
            self.fetchResult = result
            return try await fetchAssets(with: result, index: index, size: pageSize)
        }
    }
}

private extension FetchPhotoAssetUseCaseImpl {
    func handleAuthStatus(_ status: PHAuthorizationStatus) async -> Bool {
        switch status {
        case .authorized, .limited:
            return true
        case .notDetermined:
            let result = await authorizer.requestAuthorization(for: accessLevel)
            return await handleAuthStatus(result)
        case .restricted, .denied:
            return false
        @unknown default:
            return false
        }
    }
    
    func fetchAssets(with result: PHFetchResultProtocol, index: Int, size: Int) async throws -> PhotoAssetPageResult {
        let totalCount: Int = result.count
        guard index < totalCount else { throw FetchPhotoAssetError.finished }
        
        let nextIndex: Int = min(index + size, totalCount)
        
        try Task.checkCancellation()
        
        let newAssets: [PHAsset] = await result.enumeratedAssets(at: IndexSet(integersIn: index..<nextIndex), options: [])
        return PhotoAssetPageResult(assets: newAssets, nextIndex: nextIndex)
    }
}
