import SwiftUI

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
    
    var body: some Scene {
        WindowGroup {
            dependency.buildRootView()
        }
    }
}
