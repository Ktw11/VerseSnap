//
//  ModalHeightPreferenceKey.swift
//  CommonUI
//
//  Created by 공태웅 on 3/15/25.
//

import SwiftUI

struct ModalHeightPreferenceKey: PreferenceKey {
    static let defaultValue: CGFloat = 300
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
