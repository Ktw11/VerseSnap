import ProjectDescription
import ProjectDescriptionHelpers

let targetType: TargetType = .home

let project = Project(
    name: targetType.name,
    options: .commonOptions(),
    settings: .commonModule,
    targets: [
        Target.commonTarget(
            type: targetType,
            product: .framework,
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: [
                .featureInterface(type: targetType),
                .featureInterface(type: .newVerse),
                .domain,
                .shared(type: .commonUI),
                .shared(type: .utils),
                .previewSupport
            ]
        ),
        Target.interfaceTarget(type: targetType, product: .framework),
    ],
    schemes: [.debug(name: targetType.name)]
)
