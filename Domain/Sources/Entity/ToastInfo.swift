//
//  Toast.swift
//  Domain
//
//  Created by 공태웅 on 3/8/25.
//

import Foundation

public struct ToastInfo {
    public let message: LocalizedStringResource
    
    public init(message: LocalizedStringResource) {
        self.message = message
    }
}
