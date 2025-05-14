//
//  GlobalAppState.swift
//  PreviewSupport
//
//  Created by 공태웅 on 5/1/25.
//

import Foundation
import Domain

public class GlobalStateUpdatorPreview: GlobalAppStateUpdatable, @unchecked Sendable {
    
    public func addToast(info: ToastInfo) { }
    public func setScene(to scene: AppScene) { }
    public func showLoadingOverlay(_ show: Bool) { }
}

public extension GlobalStateUpdatorPreview {
    static var preview: GlobalAppStateUpdatable {
        GlobalStateUpdatorPreview()
    }
}
