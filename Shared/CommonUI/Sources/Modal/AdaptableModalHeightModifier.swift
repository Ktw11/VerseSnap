//
//  AdaptableModalHeightModifier.swift
//  CommonUI
//
//  Created by 공태웅 on 3/15/25.
//

import SwiftUI

struct AdaptableModalHeightModifier: ViewModifier {
    @State private var currentHeight: CGFloat = .zero

    private var sizeView: some View {
        GeometryReader { geometry in
            Color.clear
                .preference(key: ModalHeightPreferenceKey.self, value: geometry.size.height)
        }
    }

    func body(content: Content) -> some View {
        content
            .background(sizeView)
            .onPreferenceChange(ModalHeightPreferenceKey.self) { [$currentHeight] newHeight in
                $currentHeight.wrappedValue = newHeight
            }
            .presentationBackground(.clear)
            .presentationDragIndicator(.hidden)
            .presentationDetents([.height(currentHeight)])
    }
}
