//
//  SelectPhotoComponent.swift
//  SelectPhoto
//
//  Created by 공태웅 on 4/12/25.
//

import SwiftUI
import SelectPhotoInterface

public struct SelectPhotoComponent: SelectPhotoBuilder {
    
    // MARK: Lifecycle
    
    public init(dependency: SelectPhotoDependency) {
        self.dependency = dependency
    }
    
    // MARK: Properties
    
    private let dependency: SelectPhotoDependency
    
    // MARK: Methods
    
    @MainActor
    @ViewBuilder
    public func build(croppedImage: Binding<Image?>, ratio: CGFloat) -> SelectPhotoView {
        SelectPhotoView(
            croppedImage: croppedImage,
            viewModel: SelectPhotoViewModel(ratio: ratio, dependency: dependency)
        )
    }
}
