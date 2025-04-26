//
//  ImageResizeProvider.swift
//  App
//
//  Created by 공태웅 on 4/26/25.
//

import Foundation
import UIKit
import Domain

struct ImageResizeProvider: ImageResizable {
    func resizeImage(_ image: UIImage, minLength: CGFloat, outputScale: CGFloat) -> UIImage? {
        let size: CGSize = image.size
        let scaleFactor = max(minLength / size.width, minLength / size.height)
        let newSize = CGSize(
            width: size.width * scaleFactor,
            height: size.height * scaleFactor
        )
        
        let format = UIGraphicsImageRendererFormat()
        format.scale = outputScale
        
        let renderer = UIGraphicsImageRenderer(size: newSize, format: format)
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
}
