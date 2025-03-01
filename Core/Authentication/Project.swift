import ProjectDescription
import ProjectDescriptionHelpers

let targetType: TargetType = .authentication

let project = Project(
    name: targetType.name,
    options: .commonOptions(),
    settings: .commonModule,
    targets: [
        Target.commonTarget(
            type: targetType,
            product: .staticLibrary,
            sources: ["Sources/**"],
            dependencies: [
                .external(name: PackageProduct.kakaoSDK.rawValue)
            ]
        )
    ]
)
