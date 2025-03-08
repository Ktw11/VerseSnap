//
//  File.swift
//  CommonUI
//
//  Created by 공태웅 on 3/8/25.
//

import Foundation
import SwiftUI

public extension View {
    func attachToastWindow(toasts: Binding<[Toast]>) -> some View {
        self.modifier(ToastWindowViewModifier(toasts: toasts))
    }
}
