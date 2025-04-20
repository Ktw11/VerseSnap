import ProjectDescription
import ProjectDescriptionHelpers

let targetType: TargetType = .newDiary

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
                .domain,
                .shared(type: .commonUI),
                .shared(type: .utils),
            ]
        ),
        Target.interfaceTarget(type: targetType, product: .framework)
    ]
)
