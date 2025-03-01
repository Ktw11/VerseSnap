import SwiftUI
import ThirdPartyAuth

@main
struct VerseSnapApp: App {
    
    // MARK: Lifecycle
    
    init() {
        let dependency = DependencyContainer()
        self.dependency = dependency
        
        dependency.thirdPartyAuthProvider.configure()
    }
    
    // MARK: Properties
    
    private let dependency: DependencyContainer
    private var thirdPartyAuthProvider: ThirdPartyAuthProvidable {
        dependency.thirdPartyAuthProvider
    }
    
    var body: some Scene {
        WindowGroup {
            dependency.buildRootView()
                .onOpenURL { url in
                    handleURL(url)
                }
        }
    }
}

private extension VerseSnapApp {
    func handleURL(_ url: URL) {
        thirdPartyAuthProvider.handleURL(url)
    }
}
