//
//  SelectPhotoBuilder.swift
//  SelectPhotoInterface
//
//  Created by 공태웅 on 4/12/25.
//

import SwiftUI

public protocol SelectPhotoBuilder {
    associatedtype SomeView: View
    
    @MainActor
    @ViewBuilder
    func build(croppedImage: Binding<UIImage?>, ratio: CGFloat) -> SomeView
}
