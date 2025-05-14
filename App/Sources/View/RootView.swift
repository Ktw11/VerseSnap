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
            
            loadingOverlay
        }
        .onAppear {
            viewModel.trySignIn()
        }
    }
    
    @ViewBuilder
    private var loadingOverlay: some View {
        if viewModel.showLoadingOverlay {
            ZStack {
                Color.black.opacity(0.7)
                    .ignoresSafeArea()
                
                LoadingView()
                    .frame(alignment: .center)
            }
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
