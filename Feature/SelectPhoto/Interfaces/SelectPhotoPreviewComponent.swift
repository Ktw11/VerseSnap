//
//  SelectPhotoPreviewComponent.swift
//  SelectPhotoInterface
//
//  Created by 공태웅 on 4/22/25.
//

import SwiftUI

public struct SelectPhotoPreviewComponent: SelectPhotoBuilder {
    // MARK: Lifecycle
    
    public init() { }
    
    // MARK: Methods
    
    @MainActor
    @ViewBuilder
    public func build(croppedImage: Binding<Image?>, ratio: CGFloat) -> AnyView {
        AnyView(
            Text(verbatim: "Injected Ratio: \(ratio)")
        )
    }
}
