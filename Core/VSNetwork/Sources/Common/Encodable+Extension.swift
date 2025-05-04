//
//  Encodable+Extension.swift
//  VSNetwork
//
//  Created by 공태웅 on 5/4/25.
//

import Foundation

public extension Encodable {
    var asDictionary: [String: Any] {
        guard let data = try? JSONEncoder().encode(self),
              let dict = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            return [:]
        }
        return dict
    }
}
