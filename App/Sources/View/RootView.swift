import SwiftUI
import CommonUI
import SignInInterface
import HomeInterface
import NewDiaryInterface

struct RootView<
    SignInComponent: SignInBuilder,
    HomeComponent: HomeBuilder,
    NewDiaryComponent: NewDiaryBuilder
>: View {
    
    // MARK: Lifecycle
    
    init(
        viewModel: RootViewModel,
        signInBuilder: SignInComponent,
        homeBuilder: HomeComponent,
        newDiaryBuilder: NewDiaryComponent
    ) {
        self.viewModel = viewModel
        self.signInBuilder = signInBuilder
        self.homeBuilder = homeBuilder
        self.newDiaryBuilder = newDiaryBuilder
    }
    
    // MARK: Properites
    
    private let signInBuilder: SignInComponent
    private let homeBuilder: HomeComponent
    private let newDiaryBuilder: NewDiaryComponent
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
                signInBuilder.build()
            case .tabs:
                RootTabView(homeBuilder: homeBuilder, newDiaryBuilder: newDiaryBuilder)
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
        signInBuilder: dependency.signInBuilder,
        homeBuilder: dependency.homeBuilder,
        newDiaryBuilder: dependency.newDiaryBuilder
    )
}
