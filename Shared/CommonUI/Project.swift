import ProjectDescription
import ProjectDescriptionHelpers

let type = TargetType.commonUI

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
