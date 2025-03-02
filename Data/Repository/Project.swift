import ProjectDescription
import ProjectDescriptionHelpers

let targetType: TargetType = .repository

let project = Project(
    name: targetType.name,
    options: .commonOptions(),
    settings: .commonModule,
    targets: [
        Target.commonTarget(
            type: targetType,
            product: .staticLibrary,
            sources: ["Sources/**"]
        )
    ]
)
