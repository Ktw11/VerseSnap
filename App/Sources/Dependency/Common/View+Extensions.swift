//
//  View+Extensions.swift
//  App
//
//  Created by 공태웅 on 3/11/25.
//

import SwiftUI

extension View {
    func frame(size: CGSize) -> some View {
        frame(width: size.width, height: size.height)
    }
}
