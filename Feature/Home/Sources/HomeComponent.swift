//
//  HomeComponent.swift
//  Home
//
//  Created by 공태웅 on 3/11/25.
//

import SwiftUI
import HomeInterface

public final class HomeComponent: HomeBuilder {
    
    // MARK: Lifecycle
    
    public init(dependency: HomeDependency) {
        self.dependency = dependency
    }
    
    // MARK: Properties
    
    private let dependency: HomeDependency
    
    // MARK: Methods
    
    @MainActor
    @ViewBuilder
    public func build() -> HomeView {
        let viewModel = HomeViewModel()
        HomeView(viewModel: viewModel)
    }
}
