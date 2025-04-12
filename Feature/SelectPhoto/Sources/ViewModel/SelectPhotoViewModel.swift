//
//  PhotoPickerViewModel.swift
//  SelectPhoto
//
//  Created by 공태웅 on 4/12/25.
//

import SwiftUI
import Photos
import Domain

@MainActor
@Observable
public final class SelectPhotoViewModel {
    
    // MARK: Lifecycle
    
    public init(dependency: SelectPhotoDependency) {
        self.pageSize = dependency.pageSize
        self.useCase = dependency.useCase
    }
    
    // MARK: Properites
    
    var isAuthAlertPresented: Bool = false
    private(set) var assets: [PHAsset] = []
    private(set) var isFinished: Bool = false
    private(set) var isAuthorized: Bool = false
    
    private var isFetching: Bool = false
    private var currentIndex: Int = 0
    private let pageSize: Int
    private let useCase: FetchPhotoAssetUseCase
    
    private let cachingManager: PHCachingImageManager = {
        let manager = PHCachingImageManager()
        manager.allowsCachingHighQualityImages = true
        return manager
    }()
    private let imageRequestOptions: PHImageRequestOptions = {
        let options = PHImageRequestOptions()
        options.deliveryMode = .opportunistic
        options.isSynchronous = false
        return options
    }()
    
    // MARK: Methods
    
    func requestAuthorization() async {
        if await useCase.requestAuthorization() {
            isAuthorized = true
        } else {
            isAuthAlertPresented = true
        }
    }
    
    func openAppSettings() {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
        
        if UIApplication.shared.canOpenURL(settingsURL) {
            UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
        }
    }
    
    func didReachedBottom() async {
        guard !isFinished, !isFetching else { return }
        isFetching = true
        
        defer { isFetching = false }
        
        do {
            try Task.checkCancellation()
            
            let result = try await useCase.fetchAssets(at: currentIndex, pageSize: pageSize)
            assets.append(contentsOf: result.assets)
            currentIndex = result.nextIndex
            isFinished = result.isFinished
        } catch {
            guard let managerError = error as? FetchPhotoAssetError else { return }
            
            switch managerError {
            case .finished:
                isFinished = true
            }
        }
    }
    
    func requestImage(from asset: PHAsset, cellSize: CGSize, resultHandler: @escaping ((Image) -> Void)) -> PHImageRequestID {
        cachingManager.requestImage(
            for: asset,
            targetSize: targetSize(requested: cellSize, scale: UIScreen.main.scale),
            contentMode: .aspectFill,
            options: imageRequestOptions
        ) { uiImage, _ in
            guard let uiImage else { return }
            resultHandler(Image(uiImage: uiImage))
        }
    }
    
    func cancelImgeRequest(id: PHImageRequestID) {
        cachingManager.cancelImageRequest(id)
    }
}

private extension SelectPhotoViewModel {
    func targetSize(requested size: CGSize, scale: CGFloat) -> CGSize {
        CGSize(width: size.width * scale, height: size.height * scale)
    }
}
