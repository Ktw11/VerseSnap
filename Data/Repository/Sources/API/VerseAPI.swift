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
        let imageURLString: String
        let isKorean: Bool
        let hashtags: [String]
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
                "imageURL": params.imageURLString,
                "isKorean": params.isKorean,
                "hashtags": params.hashtags,
            ]
        }
    }
    
    var needsAuthorization: Bool {
        true
    }
}
