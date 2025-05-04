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
    
    enum Request {}
}

extension VerseAPI.Request {
    struct GenerateVerse {
        let imageData: Data
        let isKorean: Bool
    }
}

extension VerseAPI: API {
    var path: String {
        "verse/generate"
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
        }
    }
    
    var needsAuthorization: Bool {
        true
    }
}
