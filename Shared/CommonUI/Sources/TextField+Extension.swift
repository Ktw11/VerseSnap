//
//  TextField+Extension.swift
//  CommonUI
//
//  Created by 공태웅 on 4/4/25.
//

import SwiftUI

public extension TextField {
    func lengthLimit(text: Binding<String>, maxLength: Int) -> some View {
        ModifiedContent(
            content: self,
            modifier: LengthLimitModifier(
                text: text,
                maxLength: maxLength
            )
        )
    }
}
