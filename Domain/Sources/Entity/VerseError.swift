//
//  VerseError.swift
//  Domain
//
//  Created by 공태웅 on 4/24/25.
//

import Foundation

public enum VerseError: Error {
    case exceedDailyLimit
    case failedToResizeImage
    case failedToConvertImageToData
    case unknown
}
