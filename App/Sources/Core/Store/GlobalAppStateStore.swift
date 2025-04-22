//
//  GlobalAppStateStore.swift
//  App
//
//  Created by 공태웅 on 3/8/25.
//

import Foundation
import CommonUI
import Domain

@Observable
@MainActor
final class GlobalAppStateStore {
    init(toasts: [Toast] = []) {
        self.toasts = toasts
    }

    var toasts: [Toast]
}

extension GlobalAppStateStore: GlobalAppStateUpdatable {
    func addToast(info: ToastInfo) {
        toasts.append(info.toToast)
    }
}

private extension ToastInfo {
    var toToast: Toast {
        .init(message: message)
    }
}
