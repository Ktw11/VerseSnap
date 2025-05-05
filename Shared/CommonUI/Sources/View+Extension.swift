//
//  View+Extension.swift
//  CommonUI
//
//  Created by 공태웅 on 3/15/25.
//

import SwiftUI

public extension View {
    func frame(size: CGFloat) -> some View {
        frame(width: size, height: size)
    }
    
    func observeKeyboardHeight(_ binding: Binding<CGFloat>) -> some View {
        self.modifier(KeyboardHeightModifier(keyboardHeight: binding))
    }
    
    @ViewBuilder
    func conditional(_ condition: Bool, transform: (Self) -> Self) -> Self {
        condition ? transform(self) : self
    }
    
    @ViewBuilder
    func `switch`<T, Content: View>(
        on value: T,
        @ViewBuilder cases: (Self, T) -> Content
    ) -> some View {
        cases(self, value)
    }
}
