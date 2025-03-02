//
//  SignInInfoDTO.swift
//  Repository
//
//  Created by 공태웅 on 3/2/25.
//

import Foundation
import Domain

struct SignInInfoDTO {
    let refreshToken: String
    let signInType: String
}

extension SignInInfoDTO {
    var toDomain: SignInInfo {
        .init(refreshToken: refreshToken, signInType: signInType)
    }
}
