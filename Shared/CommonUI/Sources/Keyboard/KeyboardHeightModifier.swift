//
//  KeyboardHeightModifier.swift
//  CommonUI
//
//  Created by 공태웅 on 4/12/25.
//

import SwiftUI
import Combine

struct KeyboardHeightModifier: ViewModifier {
    @Binding var keyboardHeight: CGFloat
    private let keyboardObserver: KeyboardObserver = .shared
    
    func body(content: Content) -> some View {
        content
            .onReceive(Just(keyboardObserver.currentHeight)) { newHeight in
                keyboardHeight = newHeight
            }
    }
}
