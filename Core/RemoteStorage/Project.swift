import ProjectDescription
import ProjectDescriptionHelpers

let targetType: TargetType = .remoteStorage

let project = Project(
    name: targetType.name,
    options: .commonOptions(),
    settings: .commonModule,
    targets: [
        Target.commonTarget(
            type: targetType,
            product: .framework,
            sources: ["Sources/**"],
            dependencies: [
                .external(name: "FirebaseStorage"),
            ]
        )
    ]
)
