//
//  LengthLimitModifier.swift
//  CommonUI
//
//  Created by 공태웅 on 4/4/25.
//

import SwiftUI

struct LengthLimitModifier: ViewModifier {
    @Binding var text: String
    let maxLength: Int

    func body(content: Content) -> some View {
        content
            .onChange(of: text) { oldValue, newValue in
                if newValue.count > maxLength {
                    text = oldValue
                }
            }
    }
}
