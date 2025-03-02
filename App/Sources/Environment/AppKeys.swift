//
//  AppKeys.swift
//  App
//
//  Created by 공태웅 on 3/2/25.
//

import Foundation

enum AppKeys {
    
    // MARK: Definitions
    
    private enum Key {
        static let baseUrl = "BaseURL"
    }
    
    // MARK: Properties

    static let baseUrl: String = {
        guard let key = infoDictionary?[Key.baseUrl] as? String else {
            fatalError()
        }
        return key
    }()
}

private extension AppKeys {
    static var infoDictionary: [String: Any]? {
        Bundle.main.infoDictionary
    }
}
