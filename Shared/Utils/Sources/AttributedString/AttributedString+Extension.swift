//
//  AttributedString+Extension.swift
//  Utils
//
//  Created by 공태웅 on 5/11/25.
//

import SwiftUI

public extension AttributedString {
    func foreground(_ color: Color) -> Self {
        var attributed = self
        attributed.foregroundColor = color
        return attributed
    }
    
    func fonted(_ font: Font?) -> AttributedString {
        var attributed = self
        attributed.font = font
        return attributed
    }
}
