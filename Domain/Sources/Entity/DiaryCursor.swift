//
//  DiaryCursor.swift
//  Domain
//
//  Created by 공태웅 on 5/4/25.
//

import Foundation

public struct DiaryCursor: Sendable {
    public let size: Int
    public let lastCreatedAt: TimeInterval?
}
