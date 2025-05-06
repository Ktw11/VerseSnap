//
//  Locale+Extension.swift
//  Utils
//
//  Created by 공태웅 on 5/5/25.
//

import Foundation

public extension Locale {
    var isLanguageKorean: Bool {
        Locale.current.language.languageCode?.identifier == "ko"
    }
}
