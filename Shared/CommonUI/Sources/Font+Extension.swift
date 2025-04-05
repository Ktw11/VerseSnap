//
//  Font+Extension.swift
//  CommonUI
//
//  Created by 공태웅 on 4/5/25.
//

import SwiftUI

public extension Font {
    static func suite(size: CGFloat, weight: Font.Weight) -> Font? {
        switch weight {
        case .regular:
            return CommonUIFontFamily.Suite.regular.swiftUIFont(size: size)
        case .light:
            return CommonUIFontFamily.Suite.light.swiftUIFont(size: size)
        case .bold:
            return CommonUIFontFamily.Suite.bold.swiftUIFont(size: size)
        default:
            assertionFailure()
            return nil
        }
    }
    
    static func urbanist(size: CGFloat, weight: Font.Weight) -> Font? {
        switch weight {
        case .medium:
            return CommonUIFontFamily.Urbanist.medium.swiftUIFont(size: size)
        case .semibold:
            return CommonUIFontFamily.Urbanist.semiBold.swiftUIFont(size: size)
        default:
            assertionFailure()
            return nil
        }
    }
}
