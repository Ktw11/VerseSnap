import ProjectDescription
import ProjectDescriptionHelpers

let targetType: TargetType = .profile

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
                .featureInterface(type: targetType),
                .domain,
                .shared(type: .commonUI),
                .previewSupport
            ]
        ),
        Target.interfaceTarget(type: targetType, product: .framework),
    ],
    schemes: [.debug(name: targetType.name)]
)
