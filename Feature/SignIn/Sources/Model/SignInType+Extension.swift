//
//  SignInType+Extension.swift
//  SignIn
//
//  Created by 공태웅 on 2/22/25.
//

import SwiftUI

extension SignInType {
    var backgroundColor: Color {
        switch self {
        case .apple:
            return Color.white
        case .kakao:
            return SignInAsset.Color.kakaoBrand.swiftUIColor
        }
    }

    var icon: Image {
        switch self {
        case .apple:
            SignInAsset.Image.icApple.swiftUIImage
        case .kakao:
            SignInAsset.Image.icKakao.swiftUIImage
        }
    }
    
    var buttonText: String {
        switch self {
        case .apple:
            String(localized: "애플", bundle: .module)
        case .kakao:
            String(localized: "카카오", bundle: .module)
        }
    }
}
