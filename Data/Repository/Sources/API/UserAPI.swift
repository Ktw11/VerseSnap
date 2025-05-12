//
//  UserAPI.swift
//  Repository
//
//  Created by 공태웅 on 5/11/25.
//

import Foundation
import VSNetwork

enum UserAPI {
    case changeNickname(String)
}

extension UserAPI: API {
    var path: String {
        switch self {
        case .changeNickname:
            "user/nickname"
        }
    }
    
    var method: HttpMethod {
        switch self {
        case .changeNickname:
            .patch
        }
    }
    
    var bodyParameters: [String: Any]? {
        switch self {
        case let .changeNickname(value):
            ["nickname": value]
        }
    }
    
    var needsAuthorization: Bool {
        true
    }
}
