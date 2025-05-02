//
//  ImageUploadable.swift
//  RemoteStorage
//
//  Created by 공태웅 on 5/1/25.
//

import Foundation

public protocol ImageUploadable: Sendable {
    func uploadImage(imageData: Data, pathRoot: String) async throws -> URL
}
