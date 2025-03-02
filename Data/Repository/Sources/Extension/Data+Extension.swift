//
//  Data+Extension.swift
//  Repository
//
//  Created by 공태웅 on 3/2/25.
//

import Foundation

extension Data {
    func map<T: Decodable>(_ type: T.Type, using decoder: JSONDecoder = JSONDecoder()) throws -> T {
        return try decoder.decode(T.self, from: self)
    }
}
