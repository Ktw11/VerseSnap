//
//  EnvironmentValues+Extension.swift
//  App
//
//  Created by 공태웅 on 5/11/25.
//

import SwiftUI

extension EnvironmentValues {
    var userSessionContainer: UserSessionDependencyContainer? {
        get { self[UserSessionContainerKey.self] }
        set { self[UserSessionContainerKey.self] = newValue }
    }
}
