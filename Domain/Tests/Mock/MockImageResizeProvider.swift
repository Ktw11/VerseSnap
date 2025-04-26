//
//  MockImageResizeProvider.swift
//  Domain
//
//  Created by 공태웅 on 4/26/25.
//

import Foundation
import UIKit
@testable import Domain

final class MockImageResizeProvider: ImageResizable, @unchecked Sendable {
    
    var isResizeImageCalled: Bool = false
    var requestedMinLength: CGFloat?
    var requestedOutputScale: CGFloat?
    var expectedResizeImage: UIImage?
    
    func resizeImage(_ image: UIImage, minLength: CGFloat, outputScale: CGFloat) -> UIImage? {
        isResizeImageCalled = true
        requestedMinLength = minLength
        requestedOutputScale = outputScale
        
        return expectedResizeImage
    }
}
