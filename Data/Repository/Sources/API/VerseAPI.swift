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
    case listFilter(Request.ListFilter)
    
    enum Request {}
}

extension VerseAPI.Request {
    struct GenerateVerse: Encodable {
        let imageData: Data
        let isKorean: Bool
    }
    
    struct SaveVerseDiary: Encodable {
        let verse: String
        let imageURL: String
        let hashtags: [String]
    }
    
    struct ListFilter: Encodable {
        let startTimestamp: TimeInterval
        let endTimestamp: TimeInterval
        let lastCreatedAt: TimeInterval?
        let size: Int
    }
}

extension VerseAPI: API {
    var path: String {
        switch self {
        case .generate:
            "verse/generate"
        case .save:
            "verse/save"
        case .listFilter:
            "verse/list/filter"
        }
    }
    
    var method: HttpMethod {
        switch self {
        case .generate, .save:
            .post
        case .listFilter:
            .get
        }
    }
    
    var bodyParameters: [String: Any]? {
        switch self {
        case let .generate(params):
            var dict = params.asDictionary
            dict.removeValue(forKey: "imageData")
            return dict
        case let .save(params):
            return params.asDictionary
        case let .listFilter(params):
            return [:]
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
        case .save, .listFilter:
            return .json
        }
    }
    
    var headers: [String: String] {
        switch self {
        case let .listFilter(params):
            params.asDictionary.compactMapValues { "\($0)" }
        case .generate, .save:
            [:]
        }
    }
    
    var needsAuthorization: Bool {
        true
    }
}
