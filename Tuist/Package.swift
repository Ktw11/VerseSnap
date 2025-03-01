// swift-tools-version: 6.0
@preconcurrency import PackageDescription

#if TUIST
    import ProjectDescription
    import ProjectDescriptionHelpers
    import struct ProjectDescription.PackageSettings

    let packageSettings = PackageSettings(
        // Customize the product types for specific package product
        // Default is .staticFramework
        // productTypes: ["Alamofire": .framework,]
        productTypes: [PackageProduct.kakaoSDK.rawValue: .staticLibrary],
        baseSettings: .settings(configurations: Configuration.common)
    )
#endif

let package = Package(
    name: "VerseSnap",
    dependencies: [
        .package(url: "https://github.com/kakao/kakao-ios-sdk", exact: "2.23.0"),
    ]
)
