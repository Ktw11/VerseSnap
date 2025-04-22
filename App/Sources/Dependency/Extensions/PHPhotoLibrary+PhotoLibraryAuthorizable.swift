//
//  PHPhotoLibrary+PhotoLibraryAuthorizable.swift
//  App
//
//  Created by 공태웅 on 4/12/25.
//

import Foundation
import Domain
import Photos

extension PHPhotoLibrary: @retroactive PhotoLibraryAuthorizable {
    public func authorizationStatus(for accessLevel: PHAccessLevel) -> PHAuthorizationStatus {
        PHPhotoLibrary.authorizationStatus(for: accessLevel)
    }
    
    public func requestAuthorization(for accessLevel: PHAccessLevel) async -> PHAuthorizationStatus {
        await withCheckedContinuation { continuation in
            PHPhotoLibrary.requestAuthorization { status in
                continuation.resume(returning: status)
            }
        }
    }
}
