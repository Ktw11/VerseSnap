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
            return Color.yellow
        }
    }

    var icon: Image {
        switch self {
        case .apple:
            return Image(systemName: "person.circle.fill")
        case .kakao:
            return Image(systemName: "person.circle.fill")
        }
    }
    
    var buttonText: String {
        switch self {
        case .apple:
            "Apple ID"
        case .kakao:
            "카카오"
        }
    }
}
