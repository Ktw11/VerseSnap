//
//  View+Extension.swift
//  CommonUI
//
//  Created by 공태웅 on 3/15/25.
//

import SwiftUI

public extension View {
    func frame(size: CGFloat) -> some View {
        frame(width: size, height: size)
    }
}
