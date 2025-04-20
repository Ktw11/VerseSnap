import ProjectDescription
import ProjectDescriptionHelpers

let type = TargetType.utils

let project = Project(
    name: type.name,
    options: .commonOptions(),
    settings: .commonModule,
    targets: [
        Target.commonTarget(
            type: type,
            product: .framework,
            sources: ["Sources/**"]
        )
    ]
)
