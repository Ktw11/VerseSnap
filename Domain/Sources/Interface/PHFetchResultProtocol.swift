//
//  PHFetchResultProtocol.swift
//  DomainTests
//
//  Created by 공태웅 on 4/10/25.
//

import Foundation
import Photos

public protocol PHFetchResultProtocol: Sendable {
    var count: Int { get }
    func enumeratedAssets(at indexes: IndexSet, options: NSEnumerationOptions) async -> [PHAsset]
}
