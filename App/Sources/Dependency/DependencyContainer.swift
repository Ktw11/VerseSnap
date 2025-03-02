//
//  DependencyContainer.swift
//  App
//
//  Created by 공태웅 on 2/22/25.
//

import SwiftUI
import ThirdPartyAuth
import Network

final class DependencyContainer {
    
    // MARK: Properties
    
    lazy var thirdPartyAuthProvider: ThirdPartyAuthProvidable = {
        ThirdPartyAuthProvider(accounts: [.apple, .kakao])
    }()
    
    private lazy var repositoryBuilder: RepositoryBuilder = {
        RepositoryComponent(networkProvider: networkProvider)
    }()
    
    private let networkProvider: NetworkProvidable = NetworkProvider(
        configuration: NetworkConfiguration(baseUrlString: AppKeys.baseUrl)
    )
    
    // MARK: Methods
    
    @ViewBuilder
    @MainActor
    func buildRootView() -> some View {
        let viewModel = RootViewModel()
        RootView(viewModel: viewModel, signInBuilder: signInBuilder)
    }
}
