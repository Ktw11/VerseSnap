//
//  DiaryFetchResult.swift
//  Domain
//
//  Created by 공태웅 on 5/6/25.
//

import Foundation

public struct DiaryFetchResult: Decodable, Equatable, Sendable {
    
    // MARK: Lifecycle
    
    public init(diaries: [VerseDiary], isLastPage: Bool) {
        self.diaries = diaries
        self.isLastPage = isLastPage
    }
    
    // MARK: Properties
    
    public let diaries: [VerseDiary]
    public let isLastPage: Bool
}
