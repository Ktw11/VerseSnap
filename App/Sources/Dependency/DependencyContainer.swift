//
//  DependencyContainer.swift
//  App
//
//  Created by 공태웅 on 2/22/25.
//

import SwiftUI

final class DependencyContainer {
    
    // MARK: Methods
    
    @ViewBuilder
    @MainActor
    func buildRootView() -> some View {
        let viewModel = RootViewModel()
        RootView(viewModel: viewModel)
    }
}
