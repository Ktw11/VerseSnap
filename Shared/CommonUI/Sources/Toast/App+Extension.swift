//
//  App+Extension.swift
//  CommonUI
//
//  Created by 공태웅 on 3/8/25.
//

import SwiftUI
import UIKit

public extension App {
    @MainActor
    static func attachToastWindow(scene: UIWindowScene, toasts: Binding<[Toast]>) -> UIWindow {
        let window = TouchPassThroughWindow(windowScene: scene)
        
        let rootViewController = UIHostingController(rootView: ToastsView(toasts: toasts))
        rootViewController.view.frame = window.windowScene?.keyWindow?.frame ?? .zero
        rootViewController.view.backgroundColor = .clear
        
        window.rootViewController = rootViewController
        window.backgroundColor = .clear
        window.isUserInteractionEnabled = true
        window.isHidden = false
        
        return window
    }

}
