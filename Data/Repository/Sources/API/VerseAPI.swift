//
//  VerseAPI.swift
//  Repository
//
//  Created by 공태웅 on 4/24/25.
//

import Foundation
import VSNetwork

enum VerseAPI {
    case generate(imageData: Data, isKorean: Bool)
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
        case let .generate(_, isKorean):
            ["isKorean": isKorean]
        }
    }
    
    var contentType: ContentType {
        switch self {
        case let .generate(imageData, isKorean):
            return .multipart([
                MultipartFormData.MultipartFile(
                    data: imageData,
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
