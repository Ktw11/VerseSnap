//
//  AuthAPI.swift
//  Repository
//
//  Created by 공태웅 on 3/2/25.
//

import Foundation
import Network

enum AuthAPI {
    case signIn(token: String, account: String)
    case autoSignIn(refreshToken: String)
}

extension AuthAPI: API {
    var path: String {
        switch self {
        case let .signIn(_, account):
            "auth/signIn/\(account)"
        case .autoSignIn:
            "auth/autoSignIn"
        }
    }
    
    var method: Network.HttpMethod {
        switch self {
        case .signIn, .autoSignIn:
            .post
        }
    }
    
    var bodyParameters: [String: String]? {
        switch self {
        case let .signIn(token, _):
            return ["token": token]
        case let .autoSignIn(refreshToken):
            return ["refreshToken": refreshToken]
        }
    }

    var needsAuthorization: Bool {
        switch self {
        case .signIn, .autoSignIn:
            false
        }
    }
}
