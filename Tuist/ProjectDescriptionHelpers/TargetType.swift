import ProjectDescription

public enum TargetType: String, Sendable {
    case app = "App"
    case domain = "Domain"
    case signIn = "SignIn"
    case thirdPartyAuth = "ThirdPartyAuth"
    case network = "VSNetwork"
    case repository = "Repository"
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
            baseBundleId
        case .domain:
            "\(baseBundleId).Domain"
        case .signIn:
            featureBundleId
        case .thirdPartyAuth:
            coreBundleId
        case .network:
            coreBundleId
        case .repository:
            dataBundleId
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
    
    var coreBundleId: String {
        "\(baseBundleId).Core.\(self.name)"
    }
    
    var dataBundleId: String {
        "\(baseBundleId).Data.\(self.name)"
    }
}
