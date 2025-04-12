//
//  PhotoPickerCell.swift
//  SelectPhoto
//
//  Created by 공태웅 on 4/12/25.
//

import SwiftUI
import CommonUI
import Photos

struct SelectPhotoPickerCell: View {
    let asset: PHAsset
    @State private var image: Image? = nil
    @State private var imageRequestId: PHImageRequestID?
    @Environment(SelectPhotoViewModel.self) private var viewModel: SelectPhotoViewModel
    
    var body: some View {
        ZStack {
            if let image = image {
                Color.clear
                    .aspectRatio(1, contentMode: .fit)
                    .overlay {
                        image
                            .resizable()
                            .scaledToFill()
                    }
                    .clipped()
            } else {
                CommonUIAsset.Color.placeholderBG.swiftUIColor
                    .aspectRatio(1, contentMode: .fit)
                    .onGeometryChange(for: CGSize.self) { proxy in
                        proxy.size
                    } action: { newValue in
                        requestImage(size: newValue)
                    }
            }
        }
        .onDisappear {
            if let imageRequestId {
                viewModel.cancelImgeRequest(id: imageRequestId)
            }
            
            image = nil
            imageRequestId = nil
        }
    }
}

private extension SelectPhotoPickerCell {
    func requestImage(size: CGSize) {
        guard imageRequestId == nil, size.width > 0, size.height > 0 else { return }

        imageRequestId = viewModel.requestImage(from: asset, cellSize: size) { image in
            self.image = image
        }
    }
}
