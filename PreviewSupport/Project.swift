import ProjectDescription
import ProjectDescriptionHelpers

let targetType: TargetType = .previewSupport

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
                .domain,
            ]
        )
    ]
)
