//
//  LocaleGettable.swift
//  Domain
//
//  Created by 공태웅 on 4/26/25.
//

import Foundation

public protocol LocaleGettable: Sendable {
    var isLanguageKorean: Bool { get }
}
