//
//  MockGlobalStateUpdator.swift
//  SignIn
//
//  Created by 공태웅 on 3/8/25.
//

import Foundation
import Domain

class MockGlobalStateUpdator: GlobalAppStateUpdatable, @unchecked Sendable {
    static var preview: GlobalAppStateUpdatable {
        MockGlobalStateUpdator()
    }

    func addToast(info: ToastInfo) {
        // do nothing
    }
}
