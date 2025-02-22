import SwiftUI

struct RootView: View {
    
    // MARK: Lifecycle
    
    init(viewModel: RootViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: Properites
    
    private let viewModel: RootViewModel

    var body: some View {
        ZStack {
            switch viewModel.scene {
            case .splash:
                #warning("스플래시 화면 구현 필요")
                Text("@@@ SPLASH")
                    .font(.largeTitle)
            case .signIn:
                #warning("SignIn 화면 구현 필요")
                Text("@@@ SIGNIN")
                    .font(.largeTitle)
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
    RootView(viewModel: .init())
}
