//
//  ImageCropView.swift
//  SelectPhoto
//
//  Created by 공태웅 on 4/19/25.
//

import SwiftUI
import UIKit
import CommonUI

struct ImageCropView: View {
    
    // MARK: Lifecycle
    
    init(
        uiImage: UIImage,
        config: Configuration,
        didCropImage: @MainActor @escaping (UIImage) -> Void
    ) {
        self.uiImage = uiImage
        self.config = config
        self.didCropImage = didCropImage
        self.cropAreaTransformer = CropAreaTransformer(
            config: .init(ratio: config.ratio, minWidth: config.minWidth, minHeight: config.minWidth)
        )
    }
    
    // MARK: Definitions
    
    struct Configuration {
        let minimumDistanceToSelect: CGFloat
        let minWidth: CGFloat
        let minHeight: CGFloat
        let ratio: CGFloat
        
        init(
            minimumDistanceToSelect: CGFloat,
            minWidth: CGFloat,
            minHeight: CGFloat,
            ratio: CGFloat,
        ) {
            self.minimumDistanceToSelect = minimumDistanceToSelect
            self.minWidth = minWidth
            self.minHeight = minHeight
            self.ratio = ratio
        }
    }
    
    private enum Constants {
        nonisolated(unsafe) static let outerSpace: NamedCoordinateSpace = .named("image_space")
    }
    
    // MARK: Properties

    @State private var cropArea: CGRect = .zero
    @State private var imageRect: CGRect = .zero
    @State private var draggingRect: CGRect? = nil
    @State private var draggedCorner: UIRectCorner? = nil
    
    private let uiImage: UIImage
    private let didCropImage: (UIImage) -> Void
    private let config: Configuration
    private let cropAreaTransformer: CropAreaTransformer
    
    var body: some View {
        ZStack {
            CommonUIAsset.Color.mainBG.swiftUIColor
                .ignoresSafeArea()
            
            imageWithGeometry()
                .overlay {
                    ZStack {
                        Color.black.opacity(0.3)

                        ZStack {
                            Rectangle()
                                .frame(width: cropArea.width, height: cropArea.height)
                                .position(x: cropArea.midX, y: cropArea.midY)
                        }
                        .blendMode(.destinationOut)
                    }
                    .compositingGroup()
                    
                    cropView()
                }
                .coordinateSpace(Constants.outerSpace)
        }
        .toolbar {
            Button("완료") {
                didTapDone()
            }
        }
    }
    
    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                if draggingRect == nil {
                    draggingRect = cropArea
                    draggedCorner = closestCorner(at: value.startLocation, rect: cropArea)
                }

                didDragGestureChanged(value)
            }
            .onEnded { _ in
                draggingRect = nil
                draggedCorner = nil
            }
    }
}

private extension ImageCropView {
    @ViewBuilder
    func imageWithGeometry() -> some View {
        Image(uiImage: uiImage)
            .resizable()
            .scaledToFit()
            .overlay {
                GeometryReader { proxy in
                    Color.clear
                        .onGeometryChange(for: CGRect.self) {
                            $0.frame(in: Constants.outerSpace)
                        } action: { newValue in
                            self.imageRect = newValue
                        }
                }
            }
            .overlay {
                Color.clear
                    .aspectRatio(config.ratio, contentMode: .fit)
                    .overlay {
                        GeometryReader { proxy in
                            Color.clear
                                .onGeometryChange(for: CGRect.self) {
                                    $0.frame(in: Constants.outerSpace)
                                } action: { newValue in
                                    self.cropArea = newValue
                                }
                        }
                    }
            }
    }
    
    @ViewBuilder
    func cropView() -> some View {
        Group {
            gridView()
            
            conerMarkersView()
        }
        .contentShape(Rectangle())
        .border(Color.white, width: 1)
        .frame(width: cropArea.width, height: cropArea.height)
        .position(x: cropArea.midX, y: cropArea.midY)
        .simultaneousGesture(dragGesture)
    }
    
    @ViewBuilder
    func gridView() -> some View {
        ZStack {
            HStack {
                Spacer()
                Rectangle()
                    .frame(width: 0.5)
                    .frame(maxHeight: .infinity)
                Spacer()
                Rectangle()
                    .frame(width: 0.5)
                    .frame(maxHeight: .infinity)
                Spacer()
            }
            
            VStack {
                Spacer()
                Rectangle()
                    .frame(height: 0.5)
                    .frame(maxWidth: .infinity)
                Spacer()
                Rectangle()
                    .frame(height: 0.5)
                    .frame(maxWidth: .infinity)
                Spacer()
            }
        }
        .foregroundColor(Color.white.opacity(0.6))
    }
    
    @ViewBuilder
    func conerMarkersView() -> some View {
        VStack {
            HStack {
                CornerMark(corner: .topLeft)
                Spacer()
                CornerMark(corner: .topRight)
            }
            Spacer()
            HStack {
                CornerMark(corner: .bottomLeft)
                Spacer()
                CornerMark(corner: .bottomRight)
            }
        }
    }
    
    func didTapDone() {
        guard let cropped = cropImage() else { return }
        didCropImage(cropped)
    }
    
    func closestCorner(at point: CGPoint, rect: CGRect) -> UIRectCorner? {
        let isNearLeft = abs(point.x - rect.minX) < config.minimumDistanceToSelect
        let isNearRight = abs(point.x - rect.maxX) < config.minimumDistanceToSelect
        let isNearTop = abs(point.y - rect.minY) < config.minimumDistanceToSelect
        let isNearBottom = abs(point.y - rect.maxY) < config.minimumDistanceToSelect
        
        guard (isNearLeft || isNearRight) && (isNearTop || isNearBottom) else { return nil }
        
        if isNearLeft && isNearTop {
            return .topLeft
        } else if isNearRight && isNearTop {
            return .topRight
        } else if isNearLeft && isNearBottom {
            return .bottomLeft
        } else if isNearRight && isNearBottom {
            return .bottomRight
        } else {
            return nil
        }
    }
    
    func didDragGestureChanged(_ value: DragGesture.Value) {
        guard let draggingRect else { return }
        
        if let draggedCorner {
            // Resize
            guard let newArea = cropAreaTransformer.dragToResize(
                draggingRect: draggingRect,
                boundingRect: imageRect,
                draggedCorner: draggedCorner,
                translation: value.translation
            ) else { return }
            
            self.cropArea = newArea
        } else {
            // Move
            guard let newArea = cropAreaTransformer.dragToMove(
                draggingRect: draggingRect,
                boundingRect: imageRect,
                translation: value.translation
            ) else { return }

            self.cropArea = newArea
        }
    }
    
    func cropImage() -> UIImage? {
        let relativeX = (cropArea.minX - imageRect.minX) / imageRect.width
        let relativeY = (cropArea.minY - imageRect.minY) / imageRect.height
        let relativeWidth = cropArea.width / imageRect.width
        let relativeHeight = cropArea.height / imageRect.height
        
        let rectToCrop: CGRect = .init(
            x: relativeX * uiImage.size.width,
            y: relativeY * uiImage.size.height,
            width: relativeWidth * uiImage.size.width,
            height: relativeHeight * uiImage.size.height
        )
        
        guard let croppedCGImage: CGImage = uiImage.cgImage?.cropping(to: rectToCrop) else { return nil }
        
        return UIImage(
            cgImage: croppedCGImage,
            scale: uiImage.scale,
            orientation: uiImage.imageOrientation
        )
    }
}

private struct CornerMark: View {
    let corner: UIRectCorner
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Rectangle()
                .frame(width: 20, height: 3)
            
            Rectangle()
                .frame(width: 3, height: 20)
        }
        .foregroundColor(.white)
        .rotationEffect(.degrees(cornerRotation))
    }
    
    private var cornerRotation: Double {
        switch corner {
        case .topLeft: return 0
        case .topRight: return 90
        case .bottomLeft: return -90
        case .bottomRight: return 180
        default: return 0
        }
    }
}
