//
//  DomainError.swift
//  Domain
//
//  Created by 공태웅 on 4/27/25.
//

import Foundation

public enum DomainError: Error {
    case exceedDailyLimit
    case failedToConvertImageToData
    case unknown
    case cancelled
    case decodingFailed(Error)
    case failedToUploadImage
}
