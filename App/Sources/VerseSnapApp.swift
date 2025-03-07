import SwiftUI
import Domain

@main
struct VerseSnapApp: App {
    
    // MARK: Lifecycle
    
    init() {
        let dependency = DependencyContainer()
        self.dependency = dependency
        
        dependency.thirdAuthProvider.configure()
    }
    
    // MARK: Properties
    
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
        }
    }
}

private extension VerseSnapApp {
    func handleURL(_ url: URL) {
        thirdAuthProvider.handleURL(url)
    }
}
