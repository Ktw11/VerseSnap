//
//  Collection+Extension.swift
//  Utils
//
//  Created by 공태웅 on 5/5/25.
//

import Foundation

public extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
