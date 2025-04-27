//
//  GlobalAppStateUpdatable.swift
//  Domain
//
//  Created by 공태웅 on 3/8/25.
//

import Foundation

public protocol GlobalAppStateUpdatable {
    @MainActor func addToast(info: ToastInfo)
    @MainActor func setScene(to scene: AppScene)
}
