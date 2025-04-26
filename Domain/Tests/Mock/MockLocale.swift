//
//  MockLocale.swift
//  Domain
//
//  Created by 공태웅 on 4/26/25.
//

import Foundation
@testable import Domain

final class MockLocale: LocaleGettable, @unchecked Sendable {
    var isLanguageKorean: Bool = false
}
