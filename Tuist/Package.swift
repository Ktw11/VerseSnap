// swift-tools-version: 6.0
@preconcurrency import PackageDescription

#if TUIST
    import ProjectDescription
    import ProjectDescriptionHelpers
    import struct ProjectDescription.PackageSettings

    let packageSettings = PackageSettings(
        productTypes: [
            PackageProduct.kakaoSDK.rawValue: .staticLibrary,
            PackageProduct.firebase.rawValue: .framework
        ],
        baseSettings: .settings(configurations: Configuration.common)
    )
#endif

let package = Package(
    name: "VerseSnap",
    dependencies: [
        .package(url: "https://github.com/kakao/kakao-ios-sdk", exact: "2.24.0"),
        .package(url: "https://github.com/firebase/firebase-ios-sdk", exact: "11.12.0")
    ]
)
