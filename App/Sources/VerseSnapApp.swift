import SwiftUI

@main
struct VerseSnapApp: App {
    
    // MARK: Properties
    
    @State private var dependency = DependencyContainer()
    
    var body: some Scene {
        WindowGroup {
            dependency.buildRootView()
        }
    }
}
