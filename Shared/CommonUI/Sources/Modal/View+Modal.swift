//
//  View+Modal.swift
//  CommonUI
//
//  Created by 공태웅 on 3/13/25.
//

import SwiftUI

public extension View {
    @ViewBuilder
    func modalView<Content: View>(
        _ isPresented: Binding<Bool>,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        self
            .sheet(isPresented: isPresented) {
                content()
                    .safeAreaPadding()
                    .background(CommonUIAsset.Color.placeholderBG.swiftUIColor)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .frame(maxHeight: .infinity, alignment: .bottom)
                    .ignoresSafeArea()
                    .readAndBindHeight()
            }
    }
}

extension View {
    func readAndBindHeight() -> some View {
        self.modifier(AdaptableModalHeightModifier())
    }
}
