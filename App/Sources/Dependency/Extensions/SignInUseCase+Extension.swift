//
//  SignInUseCase+Extension.swift
//  App
//
//  Created by 공태웅 on 4/27/25.
//

import Foundation
import Domain
import VSNetwork

extension SignInUseCaseImpl: @retroactive TokenRefreshable { }
