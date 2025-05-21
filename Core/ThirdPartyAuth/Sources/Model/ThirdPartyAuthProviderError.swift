//
//  ThirdPartyAuthProviderError.swift
//  Authentication
//
//  Created by 공태웅 on 3/1/25.
//

import Foundation

public enum ThirdPartyAuthProviderError: Error {
    case failedToGetToken
    case invalidAccount
    case notFoundAccount
}
