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
                .shared(type: .commonUI),
                .previewSupport
            ]
        ),
        Target.interfaceTarget(type: .signIn, product: .framework)
    ],
    schemes: [.debug(name: targetType.name)]
)
