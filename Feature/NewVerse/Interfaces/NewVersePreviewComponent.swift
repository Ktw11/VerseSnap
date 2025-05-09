//
//  NewVersePreviewComponent.swift
//  NewVerseInterface
//
//  Created by 공태웅 on 5/9/25.
//

import SwiftUI

#if DEBUG
public final class NewVersePreviewComponent: NewVerseBuilder {
    
    // MARK: Lifecycle
    
    public init() { }
    
    // MARK: Methods
    
    @MainActor
    @ViewBuilder
    public func build(isPresented: Binding<Bool>) -> some View {
        Text(verbatim: "NewVerseView")
    }
}
#endif
