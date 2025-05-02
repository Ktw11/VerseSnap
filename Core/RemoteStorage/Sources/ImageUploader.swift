//
//  ImageUploader.swift
//  RemoteStorage
//
//  Created by 공태웅 on 5/1/25.
//

import Foundation
import Domain
@preconcurrency import FirebaseStorage

public actor ImageUploader: ImageUploadable {
    
    // MARK: Lifecycle
    
    public init(storage: Storage = .storage()) {
        self.storage = storage
    }
    
    // MARK: Properties
    
    private let storage: Storage
    
    // MARK: Methods
    
    public func uploadImage(imageData: Data, pathRoot: String) async throws -> URL {
        let imageName = UUID().uuidString + String(Date().timeIntervalSince1970)
        let reference = storage.reference().child("\(pathRoot)/(imageName)")
        
        do {
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpeg"
            _ = try await reference.putDataAsync(imageData, metadata: metaData)
        } catch {
            throw ImageUploaderError.failToUploadImage
        }
        
        do {
            return try await reference.downloadURL()
        } catch {
            throw ImageUploaderError.failToDownloadURL
        }
    }
}
