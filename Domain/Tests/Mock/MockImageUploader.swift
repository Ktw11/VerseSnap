//
//  MockImageUploader.swift
//  DomainTests
//
//  Created by 공태웅 on 5/2/25.
//

import Foundation
@testable import Domain

final class MockImageUploader: ImageUploadable, @unchecked Sendable {
    
    var isUploadImageCalled: Bool = false
    var expectedUploadImage: URL?
    var expectedUploadImageError: Error?
    
    func uploadImage(imageData: Data, pathRoot: String) async throws -> URL {
        isUploadImageCalled = true
        
        if let expectedUploadImage {
            return expectedUploadImage
        } else if let expectedUploadImageError {
            throw expectedUploadImageError
        } else {
            throw TestError.notImplemented
        }
    }
}
