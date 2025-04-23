//
//  PhotoLibraryAuthorizable.swift
//  Domain
//
//  Created by 공태웅 on 4/9/25.
//

import Foundation
import Photos

public protocol PhotoLibraryAuthorizable: Sendable {
    func authorizationStatus(for accessLevel: PHAccessLevel) -> PHAuthorizationStatus
    func requestAuthorization(for accessLevel: PHAccessLevel) async -> PHAuthorizationStatus
}
