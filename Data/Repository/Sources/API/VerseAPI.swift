//
//  VerseAPI.swift
//  Repository
//
//  Created by 공태웅 on 4/24/25.
//

import Foundation
import VSNetwork

enum VerseAPI {
    case generate(Request.GenerateVerse)
    case save(Request.SaveVerseDiary)
    
    enum Request {}
}

extension VerseAPI.Request {
    struct GenerateVerse {
        let imageData: Data
        let isKorean: Bool
    }
    
    struct SaveVerseDiary {
        let verse: String
        let imageURL: String
        let hashtags: [String]
    }
}

extension VerseAPI: API {
    var path: String {
        switch self {
        case .generate:
            "verse/generate"
        case .save:
            "verse/save"
        }
    }
    
    var method: HttpMethod {
        .post
    }
    
    var bodyParameters: [String: Any]? {
        switch self {
        case let .generate(params):
            [
                "imageURL": params.imageData,
                "isKorean": params.isKorean,
            ]
        case let .save(params):
            [
                "verse": params.verse,
                "imageURL": params.imageURL,
                "hashtags": params.hashtags,
            ]
        }
    }
    
    var contentType: ContentType {
        switch self {
        case let .generate(params):
            return .multipart([
                MultipartFormData.MultipartFile(
                    data: params.imageData,
                    name: "image",
                    fileName: "image.jpg",
                    mimeType: "image/jpeg"
                )
            ])
        case .save:
            return .json
        }
    }
    
    var needsAuthorization: Bool {
        true
    }
}
