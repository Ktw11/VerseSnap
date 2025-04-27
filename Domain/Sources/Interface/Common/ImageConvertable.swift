//
//  ImageConvertable.swift
//  Domain
//
//  Created by 공태웅 on 4/26/25.
//

import UIKit

public protocol ImageConvertable: Sendable {
    func convertToJpegData(
        _ image: UIImage,
        minLength: CGFloat,
        outputScale: CGFloat,
        maxKB: Int
    ) -> Data?
}
