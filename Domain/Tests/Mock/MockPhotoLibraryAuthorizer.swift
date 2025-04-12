//
//  MockPhotoLibraryAuthorizer.swift
//  DomainTests
//
//  Created by 공태웅 on 4/9/25.
//

import Foundation
import Photos
@testable import Domain

final class MockPhotoLibraryAuthorizer: PhotoLibraryAuthorizable, @unchecked Sendable {
    var expectedAuthorizationStatus: PHAuthorizationStatus!
    var isRequestAuthorizationCalled: Bool = false
    var expectedRequestAuthorization: PHAuthorizationStatus!
    
    func authorizationStatus(for accessLevel: PHAccessLevel) -> PHAuthorizationStatus {
        expectedAuthorizationStatus
    }
    
    func requestAuthorization(for accessLevel: PHAccessLevel) async -> PHAuthorizationStatus {
        isRequestAuthorizationCalled = true
        return expectedRequestAuthorization
    }
}
