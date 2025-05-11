import SwiftUI
import CommonUI
import SignInInterface
import HomeInterface
import NewVerseInterface

struct RootView: View {
    
    // MARK: Lifecycle
    
    init(
        viewModel: RootViewModel,
        dependency: DependencyContainer
    ) {
        self.viewModel = viewModel
        self.dependency = dependency
    }
    
    // MARK: Properites
    
    private let dependency: DependencyContainer
    private let viewModel: RootViewModel

    var body: some View {
        ZStack {
            CommonUIAsset.Color.mainBG.swiftUIColor
                .ignoresSafeArea()

            switch viewModel.scene {
            case .splash:
                #warning("스플래시 화면 구현 필요")
                Text("@@@ SPLASH")
                    .font(.largeTitle)
            case .signIn:
                dependency.signInBuilder.build()
            case let .tabs(user):
                dependency.buildRootTabView(user: user)
            }
        }
        .onAppear {
            viewModel.trySignIn()
        }
    }
}

#if DEBUG
import PreviewSupport

#Preview {
    let dependency = DependencyContainer()
    RootView(
        viewModel: RootViewModel(
            appStateStore: GlobalAppStateStore(),
            useCase: AuthUseCasePreview.preview
        ),
        dependency: dependency
    )
}
#endif
