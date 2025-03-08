//
//  ToastWindowViewModifier.swift
//  CommonUI
//
//  Created by 공태웅 on 3/8/25.
//

import SwiftUI

struct ToastWindowViewModifier: ViewModifier {
    
    // MARK: Lifecycle
    
    @Binding var toasts: [Toast]
    @State private var toastWindow: UIWindow?
    
    // MARK: Method
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                setUpWindow()
            }
    }
}

private extension ToastWindowViewModifier {
    func setUpWindow() {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        guard toastWindow == nil else { return }
        
        let window = TouchPassThroughWindow(windowScene: scene)
        let rootViewController = UIHostingController(rootView: ToastsView(toasts: $toasts))
        rootViewController.view.frame = window.windowScene?.keyWindow?.frame ?? .zero
        rootViewController.view.backgroundColor = .clear
        
        window.rootViewController = rootViewController
        window.backgroundColor = .clear
        window.isUserInteractionEnabled = true
        window.isHidden = false
        toastWindow = window
    }
}
