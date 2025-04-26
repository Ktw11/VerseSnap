//
//  Locale+LocaleGettable.swift
//  App
//
//  Created by 공태웅 on 4/26/25.
//

import Foundation
import Domain

extension Locale: @retroactive LocaleGettable {
    public var isLanguageKorean: Bool {
        Locale.current.language.languageCode?.identifier == "ko"
    }
}
