//
//  ImageResizable.swift
//  Domain
//
//  Created by 공태웅 on 4/26/25.
//

import UIKit

public protocol ImageResizable: Sendable {
    func resizeImage(_ image: UIImage, minLength: CGFloat, outputScale: CGFloat) -> UIImage?
}
