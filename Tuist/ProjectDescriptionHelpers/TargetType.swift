import ProjectDescription

public enum TargetType: String, Sendable {
    // App
    case verseSnap = "VerseSnap"
    
    // Domain
    case domain = "Domain"
    
    // Feature
    case signIn = "SignIn"
    case home = "Home"
    case newVerse = "NewVerse"
    case selectPhoto = "SelectPhoto"
    case profile = "Profile"
    
    // Core
    case thirdPartyAuth = "ThirdPartyAuth"
    case remoteStorage = "RemoteStorage"
    case network = "VSNetwork"
    
    // Repository
    case repository = "Repository"
    
    // Preview
    case previewSupport = "PreviewSupport"
    
    // Shared
    case commonUI = "CommonUI"
    case utils = "Utils"
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
        case .verseSnap:
            baseBundleId
        case .domain:
            "\(baseBundleId).Domain"
        case .signIn,
                .home,
                .newVerse,
                .selectPhoto,
                .profile:
            featureBundleId
        case .thirdPartyAuth, .network, .remoteStorage:
            coreBundleId
        case .repository:
            dataBundleId
        case .previewSupport:
            "\(baseBundleId).PreviewSupport"
        case .commonUI, .utils:
            sharedBundleId
        }
    }
    
    var interfaceBundleId: String {
        "\(baseBundleId).Feature.\(interfaceName)"
    }
    
    var testBundleId: String {
        "\(baseBundleId).\(bundleId).Test"
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
    
    var sharedBundleId: String {
        "\(baseBundleId).Shared.\(self.name)"
    }
}
