//
//  MockImageConverter.swift
//  Domain
//
//  Created by 공태웅 on 4/26/25.
//

import Foundation
import UIKit
@testable import Domain

final class MockImageConverter: ImageConvertable, @unchecked Sendable {
    
    var isConvertToJpegDataCalled: Bool = false
    var requestedMinLength: CGFloat?
    var requestedOutputScale: CGFloat?
    var requestedMaxKB: Int?
    var expectedConvertToJpegData: Data?

    func convertToJpegData(
        _ image: UIImage,
        minLength: CGFloat,
        outputScale: CGFloat,
        maxKB: Int
    ) -> Data? {
        isConvertToJpegDataCalled = true
        requestedMinLength = minLength
        requestedOutputScale = outputScale
        requestedMaxKB = maxKB
        return expectedConvertToJpegData
    }
}
