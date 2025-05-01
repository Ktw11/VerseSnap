//
//  SelectPhotoPreviewComponent.swift
//  SelectPhotoInterface
//
//  Created by 공태웅 on 4/22/25.
//

import SwiftUI

#if DEBUG
public struct SelectPhotoPreviewComponent: SelectPhotoBuilder {
    // MARK: Lifecycle
    
    public init() { }
    
    // MARK: Methods
    
    @MainActor
    @ViewBuilder
    public func build(croppedImage: Binding<UIImage?>, ratio: CGFloat) -> AnyView {
        AnyView(SelectPhotoPreviewView(uiImage: croppedImage, ratio: ratio))
    }
}

private struct SelectPhotoPreviewView: View {
    
    @Binding var uiImage: UIImage?
    let ratio: CGFloat
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Button(action: {
            uiImage = UIImage(systemName: "star.fill")
            
            dismiss()
        }, label: {
            Text(verbatim: "Injected Ratio: \(ratio)")
                .foregroundStyle(Color.white)
        })
    }
}

#endif
