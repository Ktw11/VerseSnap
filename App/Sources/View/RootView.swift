import SwiftUI
import SignInInterface

struct RootView<Builder: SignInBuilder>: View {
    
    // MARK: Lifecycle
    
    init(viewModel: RootViewModel, signInBuilder: Builder) {
        self.viewModel = viewModel
        self.signInBuilder = signInBuilder
    }
    
    // MARK: Properites
    
    private let signInBuilder: Builder
    private let viewModel: RootViewModel

    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()

            switch viewModel.scene {
            case .splash:
                #warning("스플래시 화면 구현 필요")
                Text("@@@ SPLASH")
                    .font(.largeTitle)
            case .signIn:
                signInBuilder.build()
            case .tabs:
                #warning("Tab 화면 구현 필요")
                Text("@@@ TAB")
                    .font(.largeTitle)
            }
        }
        .onAppear {
            viewModel.trySignIn()
        }
    }
}


#Preview {
    let dependency = DependencyContainer()
    RootView(
        viewModel: dependency.mockRootViewModel,
        signInBuilder: dependency.signInBuilder
    )
}
