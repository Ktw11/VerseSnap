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
            }
        }
        .onAppear {
            Task {
                _ = try? await Task.sleep(nanoseconds: 2000000000)
                viewModel.scene = .signIn
            }
        }
    }
}


#Preview {
    let dependency = DependencyContainer()
    RootView(viewModel: .init(), signInBuilder: dependency.signInBuilder)
}
