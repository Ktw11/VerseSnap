public enum TargetType: String, Sendable {
    case app = "App"
}

public extension TargetType {
    var name: String {
        self.rawValue
    }
    
    var bundleId: String {
        switch self {
        case .app:
            return baseBundleId
        }
    }
}

private extension TargetType {
    var baseBundleId: String {
        "gtw.VerseSnap"
    }
}
