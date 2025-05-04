//
//  ImageConverter.swift
//  App
//
//  Created by 공태웅 on 4/26/25.
//

import Foundation
import UIKit
import Domain

struct ImageConverter: ImageConvertable {
    
    // MARK: Definitions
    
    private enum Constants {
        static let maxNumberOfAttemptsToCompress: Int = 6
    }
    
    func convertToJpegData(
        _ image: UIImage,
        minLength: CGFloat,
        outputScale: CGFloat,
        maxKB: Int
    ) -> Data? {
        guard let resizedImage = resizeImage(image, minLength: minLength, outputScale: outputScale) else { return nil }
        return compressedJpegData(resizedImage, compressTo: maxKB)
    }
}

private extension ImageConverter {
    func resizeImage(
        _ image: UIImage,
        minLength: CGFloat,
        outputScale: CGFloat
    ) -> UIImage? {
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
    
    func compressedJpegData(_ image: UIImage, compressTo maxKB: Int) -> Data? {
        let maxBytes: Int = maxKB * 1024
        var minQuality: CGFloat = 0.3
        var maxQuality: CGFloat = 0.9

        guard var data = image.jpegData(compressionQuality: maxQuality) else { return nil }
        guard data.count > maxBytes else { return data }
        
        for _ in 0..<Constants.maxNumberOfAttemptsToCompress {
            let midQuality = (minQuality + maxQuality) / 2
            guard let midData = image.jpegData(compressionQuality: midQuality) else { break }
            data = midData
            
            if midData.count > maxBytes {
                maxQuality = midQuality
            } else {
                minQuality = midQuality
            }
        }
        
        return data
    }
}
