//
//  VerseAPI.swift
//  Repository
//
//  Created by 공태웅 on 4/24/25.
//

import Foundation
import VSNetwork

enum VerseAPI {
    case generate(encodedImage: String, isKorean: Bool)
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
        case let .generate(encodedImage, isKorean):
            ["image": encodedImage, "isKorean": isKorean]
        }
    }
    
    var needsAuthorization: Bool {
        true
    }
}
