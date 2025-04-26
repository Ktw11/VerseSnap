import SwiftUI
import CommonUI
import SignInInterface
import HomeInterface
import NewVerseInterface

struct RootView<
    SignInComponent: SignInBuilder,
    HomeComponent: HomeBuilder,
    NewVerseComponent: NewVerseBuilder
>: View {
    
    // MARK: Lifecycle
    
    init(
        viewModel: RootViewModel,
        signInBuilder: SignInComponent,
        homeBuilder: HomeComponent,
        newVerseBuilder: NewVerseComponent
    ) {
        self.viewModel = viewModel
        self.signInBuilder = signInBuilder
        self.homeBuilder = homeBuilder
        self.newVerseBuilder = newVerseBuilder
    }
    
    // MARK: Properites
    
    private let signInBuilder: SignInComponent
    private let homeBuilder: HomeComponent
    private let newVerseBuilder: NewVerseComponent
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
                RootTabView(homeBuilder: homeBuilder, newVerseBuilder: newVerseBuilder)
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
        newVerseBuilder: dependency.newVerseBuilder
    )
}
