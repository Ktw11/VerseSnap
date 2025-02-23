import ProjectDescription
import ProjectDescriptionHelpers

let targetType: TargetType = .signIn

let project = Project(
    name: targetType.name,
    settings: .commonModule,
    targets: [
        Target.commonTarget(
            type: .signIn,
            product: .framework,
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: [
                .featureInterface(type: targetType)
            ]
        ),
        Target.interfaceTarget(type: .signIn, product: .framework)
    ]
)
