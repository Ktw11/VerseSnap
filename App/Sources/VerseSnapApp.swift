import SwiftUI
import Domain
import CommonUI

@main
struct VerseSnapApp: App {
    
    // MARK: Lifecycle
    
    init() {
        let dependency = DependencyContainer()
        self.dependency = dependency
        dependency.thirdAuthProvider.configure()
    }
    
    // MARK: Properties
    
    @State private var toastWindow: UIWindow?
    private let dependency: DependencyContainer
    private var thirdAuthProvider: ThirdPartyAuthProvidable {
        dependency.thirdAuthProvider
    }
    
    var body: some Scene {
        WindowGroup {
            dependency.buildRootView()
                .onOpenURL { url in
                    handleURL(url)
                }
                .onAppear {
                    setUpToastWindow()
                }
        }
    }
}

private extension VerseSnapApp {
    func handleURL(_ url: URL) {
        thirdAuthProvider.handleURL(url)
    }
    
    func setUpToastWindow() {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        guard toastWindow == nil else { return }
        
        @Bindable var bindableState = dependency.appStateStore
        toastWindow = Self.attachToastWindow(scene: scene, toasts: $bindableState.toasts)
    }
}
