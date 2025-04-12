//
//  DummyPHAsset.swift
//  DomainTests
//
//  Created by 공태웅 on 4/10/25.
//

import Foundation
import Photos

final class DummyPHAsset: PHAsset, @unchecked Sendable {
    
    init(identifier: String) {
        self.id = identifier
        super.init()
    }
    
    var identifier: String {
        return id
    }
    
    private let id: String
}
