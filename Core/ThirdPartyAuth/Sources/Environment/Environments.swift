//
//  Environments.swift
//  Authentication
//
//  Created by 공태웅 on 3/1/25.
//

import Foundation

enum Environments {
    // MARK: Definitions
    
    private enum Key {
        static let kakaoAppKey = "KakaoAppKey"
    }
    
    // MARK: Properties
    
    static let kakaoAppKey: String = {
        guard let key = infoDictionary?[Key.kakaoAppKey] as? String else {
            fatalError()
        }
        return key
    }()
}

private extension Environments {
    static var infoDictionary: [String: Any]? {
        Bundle.main.infoDictionary
    }
}
