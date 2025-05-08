//
//  Hashtag.swift
//  CommonUI
//
//  Created by 공태웅 on 5/8/25.
//

import Foundation

public struct Hashtag: Identifiable, Equatable {
    
    // MARK: Lifecycle
    
    public init(id: UUID = UUID(), value: String) {
        self.id = id
        self.value = value
    }
    
    // MARK: Properties
    
    public var id: UUID = UUID()
    public var value: String
}
