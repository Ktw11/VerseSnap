import ProjectDescription

public enum TargetType: String, Sendable {
    case app = "App"
    case signIn = "SignIn"
}

public extension TargetType {
    var name: String {
        self.rawValue
    }
    
    var interfaceName: String {
        "\(self.name)Interface"
    }
    
    var bundleId: String {
        switch self {
        case .app:
            return baseBundleId
        case .signIn:
            return featureBundleId
        }
    }
    
    var interfaceBundleId: String {
        "\(baseBundleId).Feature.\(interfaceName)"
    }
}

private extension TargetType {
    var baseBundleId: String {
        "gtw.VerseSnap"
    }
    
    var featureBundleId: String {
        "\(baseBundleId).Feature.\(self.name)"
    }
}
