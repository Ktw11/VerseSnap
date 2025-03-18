//
//  WrappingLayoutView.swift
//  CommonUI
//
//  Created by 공태웅 on 3/16/25.
//

import SwiftUI

public struct WrappingLayoutView<Content: View, Item: Identifiable>: View {
    
    // MARK: Lifecycle
    
    public init(
        items: Binding<[Item]>,
        hSpacing: CGFloat = 2,
        vSpacing: CGFloat = 2,
        trailingContent: @escaping () -> Content? = { nil },
        content: @escaping (Item) -> Content
    ) {
        self._items = items
        self.hSpacing = hSpacing
        self.vSpacing = vSpacing
        self.trailingContent = trailingContent
        self.content = content
    }
    
    // MARK: Properties
    
    @Binding var items: [Item]
    @ViewBuilder var trailingContent: () -> Content?
    @ViewBuilder var content: (Item) -> Content
    private let hSpacing: CGFloat
    private let vSpacing: CGFloat
    
    public var body: some View {
        WrappingLayout(hSpacing: hSpacing, vSpacing: vSpacing) {
            ForEach(items) { item in
                content(item)
            }
            
            trailingContent()
        }
    }
}
