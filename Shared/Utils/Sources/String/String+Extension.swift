//
//  String+Extension.swift
//  Utils
//
//  Created by 공태웅 on 5/5/25.
//

import Foundation

public extension String {
    func firstLetters(separator: String) -> String {
        self.components(separatedBy: .newlines)
          .compactMap { $0.first }
          .map(String.init)
          .joined(separator: separator)
    }
}
