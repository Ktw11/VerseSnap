//
//  String+Extension.swift
//  Utils
//
//  Created by 공태웅 on 5/5/25.
//

import SwiftUI

public extension [String] {
    func highlightFirstCharacterOfEachLine(highlightedFont: Font?, regularFont: Font?) -> AttributedString {
        let lines = self
        var result = AttributedString()
        
        for (index, line) in lines.enumerated() {
            guard !line.isEmpty else { continue }
            
            var attributedLine = AttributedString(line)
            
            let startIndex: AttributedString.Index = attributedLine.startIndex
            let endIndex: AttributedString.Index = attributedLine.index(afterCharacter: startIndex)
            attributedLine[startIndex..<endIndex].font = highlightedFont
            attributedLine[endIndex...].font = regularFont
            
            result.append(attributedLine)

            if index < lines.count - 1 {
                result.append(AttributedString("\n"))
            }
        }
        
        return result
    }
    
    func firstLetters(separator: String) -> String {
        self
          .compactMap { $0.first }
          .map(String.init)
          .filter { !$0.isEmpty }
          .joined(separator: separator)
    }
}
