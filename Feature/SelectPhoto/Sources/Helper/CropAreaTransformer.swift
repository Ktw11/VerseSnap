//
//  CropAreaTransformer.swift
//  SelectPhoto
//
//  Created by 공태웅 on 4/19/25.
//

import Foundation
import UIKit

struct CropAreaTransformer: Sendable {
    
    // MARK: Lifecycle
    
    init(config: Configuration) {
        self.config = config
    }
    
    // MARK: Definitions
    
    struct Configuration {
        let ratio: CGFloat
        let minWidth: CGFloat
        let minHeight: CGFloat
    }
    
    // MARK: Properties
    
    private let config: Configuration
    
    // MARK: Method
    
    @MainActor
    func dragToResize(
        draggingRect: CGRect,
        boundingRect: CGRect,
        draggedCorner: UIRectCorner,
        translation: CGSize
    ) -> CGRect? {
        // deicde anchor and dragPoint with draggedCorner
        guard let (anchor, dragPoint) = calculateDraggedPoints(
            for: draggedCorner,
            rect: draggingRect,
            translation: translation
        ) else { return nil }
        
        let convertedDragPoint: CGPoint = .init(
            x: min(max(dragPoint.x, boundingRect.minX), boundingRect.maxX),
            y: min(max(dragPoint.y, boundingRect.minY), boundingRect.maxY)
        )
        let vectorX: CGFloat = convertedDragPoint.x - anchor.x
        let vectorY: CGFloat = convertedDragPoint.y - anchor.y
        
        // decide dominating direction
        let widthFromWidth: CGFloat = abs(vectorX)
        let widthFromHeight: CGFloat = abs(vectorY) * config.ratio
        let newWidth: CGFloat = max(widthFromWidth, widthFromHeight)
        let newHeight: CGFloat = newWidth / config.ratio
        
        // calculate new Rect
        guard let newRect: CGRect = calculateDraggedRect(
            for: draggedCorner,
            anchor: anchor,
            newWidth: newWidth,
            newHeight: newHeight
        ) else { return nil }
        
        guard validateRect(newRect, within: boundingRect) else {
            return nil
        }
        
        return newRect
    }

    @MainActor
    func dragToMove(
        draggingRect: CGRect,
        boundingRect: CGRect,
        translation: CGSize
    ) -> CGRect? {
        let draggedPoint: CGPoint = .init(
            x: draggingRect.origin.x + translation.width,
            y: draggingRect.origin.y + translation.height
        )
        let convertedDragPoint: CGPoint = .init(
            x: min(max(draggedPoint.x, boundingRect.minX), boundingRect.maxX - draggingRect.width),
            y: min(max(draggedPoint.y, boundingRect.minY), boundingRect.maxY - draggingRect.height)
        )
        return CGRect(
            x: convertedDragPoint.x,
            y: convertedDragPoint.y,
            width: draggingRect.width,
            height: draggingRect.height
        )
    }
}

private extension CropAreaTransformer {
    func validateRect(_ rect: CGRect, within boundingRect: CGRect) -> Bool {
        rect.width >= config.minWidth
        && rect.height >= config.minHeight
        && rect.minX >= 0
        && rect.minY >= 0
        && boundingRect.contains(rect)
    }
    
    func calculateDraggedPoints(
        for corner: UIRectCorner,
        rect: CGRect,
        translation: CGSize
    ) -> (anchor: CGPoint, dragPoint: CGPoint)? {
        switch corner {
        case .topLeft:
            return (
                anchor: CGPoint(x: rect.maxX, y: rect.maxY),
                dragPoint: CGPoint(
                    x: rect.minX + translation.width,
                    y: rect.minY + translation.height
                )
            )
        case .topRight:
            return (
                anchor: CGPoint(x: rect.minX, y: rect.maxY),
                dragPoint: CGPoint(
                    x: rect.maxX + translation.width,
                    y: rect.minY + translation.height
                )
            )
        case .bottomLeft:
            return (
                anchor: CGPoint(x: rect.maxX, y: rect.minY),
                dragPoint: CGPoint(
                    x: rect.minX + translation.width,
                    y: rect.maxY + translation.height
                )
            )
        case .bottomRight:
            return (
                anchor: CGPoint(x: rect.minX, y: rect.minY),
                dragPoint: CGPoint(
                    x: rect.maxX + translation.width,
                    y: rect.maxY + translation.height
                )
            )
        default:
            return nil
        }
    }
    
    func calculateDraggedRect(
        for corner: UIRectCorner,
        anchor: CGPoint,
        newWidth: CGFloat,
        newHeight: CGFloat
    ) -> CGRect? {
        switch corner {
        case .topLeft:
            return CGRect(
                x: anchor.x - newWidth,
                y: anchor.y - newHeight,
                width: newWidth,
                height: newHeight
            )
        case .topRight:
            return CGRect(
                x: anchor.x,
                y: anchor.y - newHeight,
                width: newWidth,
                height: newHeight
            )
        case .bottomLeft:
            return CGRect(
                x: anchor.x - newWidth,
                y: anchor.y,
                width: newWidth,
                height: newHeight
            )
        case .bottomRight:
            return CGRect(
                x: anchor.x,
                y: anchor.y,
                width: newWidth,
                height: newHeight
            )
        default:
            return nil
        }
    }
}
