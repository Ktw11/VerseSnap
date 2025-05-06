//
//  LoadingView.swift
//  CommonUI
//
//  Created by 공태웅 on 3/8/25.
//

import SwiftUI

public struct LoadingView: View {
    
    // MARK: Lifecycle
    
    public init(
        size: CGFloat = 25
    ) {
        self.size = size
    }
    
    // MARK: Properties
    
    @State private var animate = false
    private let size: CGFloat
    
    private let gradient = LinearGradient(
        stops: [
            Gradient.Stop(color: .white, location: 0),
            Gradient.Stop(color: .white.opacity(0.4), location: 1.0)
        ],
        startPoint: .leading,
        endPoint: .trailing
    )
    
    public var body: some View {
        Circle()
            .stroke(gradient, lineWidth: 2.5)
            .frame(width: size, height: size)
            .rotationEffect(Angle(degrees: animate ? 360 : 0))
            .animation(
                .linear(duration: 1)
                .repeatForever(autoreverses: false),
                value: animate
            )
            .onAppear {
                animate.toggle()
            }
    }
}
