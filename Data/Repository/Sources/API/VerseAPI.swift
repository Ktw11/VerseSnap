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
    case listAll(Request.ListAll)
    case updateFavorite(Request.UpdateFavorite)
    
    enum Request {}
}

extension VerseAPI.Request {
    struct GenerateVerse {
        let imageData: Data
        let isKorean: Bool
    }
    
    struct SaveVerseDiary: Encodable {
        let verses: [String]
        let imageURL: String
        let hashtags: [String]
    }
    
    struct ListFilter: Encodable {
        let startTimestamp: TimeInterval
        let endTimestamp: TimeInterval
        let lastCreatedAt: TimeInterval?
        let size: Int
    }
    
    struct ListAll: Encodable {
        let lastCreatedAt: TimeInterval?
        let size: Int
    }
    
    struct UpdateFavorite: Encodable {
        enum CodingKeys: String, CodingKey {
            case id = "verseId"
            case isFavorite
        }
        
        let id: String
        let isFavorite: Bool
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
        case .listAll:
            "verse/list/latest"
        case .updateFavorite:
            "verse/favorite"
        }
    }
    
    var method: HttpMethod {
        switch self {
        case .generate, .save:
            .post
        case .listFilter, .listAll:
            .get
        case .updateFavorite:
            .patch
        }
    }
    
    var queryParameters: [String: String]? {
        switch self {
        case .generate, .save, .updateFavorite:
            return nil
        case let .listFilter(params):
            return params.asDictionary.compactMapValues { "\($0)" }
        case let .listAll(params):
            return params.asDictionary.compactMapValues { "\($0)" }
        }
    }
    
    var bodyParameters: [String: Any]? {
        switch self {
        case let .generate(params):
            return ["isKorean": params.isKorean]
        case let .save(params):
            return params.asDictionary
        case let .updateFavorite(params):
            return params.asDictionary
        case .listFilter, .listAll:
            return nil
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
        case .save, .listFilter, .listAll, .updateFavorite:
            return .json
        }
    }
    
    var needsAuthorization: Bool {
        true
    }
}
