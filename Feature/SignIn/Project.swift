import ProjectDescription
import ProjectDescriptionHelpers

let targetType: TargetType = .signIn

let project = Project(
    name: targetType.name,
    options: .commonOptions(),
    settings: .commonModule,
    targets: [
        Target.commonTarget(
            type: .signIn,
            product: .framework,
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: [
                .featureInterface(type: targetType),
                .domain,
                .core(type: .thirdPartyAuth)
            ]
        ),
        Target.interfaceTarget(type: .signIn, product: .framework)
    ]
)
