//
//  CachedRemoteResource.swift
//  CommonUI
//
//  Created by 공태웅 on 5/8/25.
//

import SwiftUI
import Kingfisher

public enum CachedRemoteResource {
    public static func fetchImage(url: URL) async throws -> Image {
        let result = try await KingfisherManager.shared.retrieveImage(with: url)
        return Image(uiImage: result.image)
    }
}
