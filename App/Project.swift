import ProjectDescription
import ProjectDescriptionHelpers

let type = TargetType.app

let project = Project(
    name: type.name,
    options: .options(
        defaultKnownRegions: ["en", "ko"],
        developmentRegion: "ko"
    ),
    settings: .commonModule,
    targets: [
        Target.commonTarget(
            type: type,
            product: .app,
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                ]
            ),
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: [
                .feature(type: .signIn),
                .featureInterface(type: .signIn)
            ]
        )
    ],
    schemes: [
        .scheme(
            name: "App-dev",
            buildAction: .buildAction(targets: [.target(type.name)]),
            runAction: .runAction(configuration: BuildTarget.dev.configurationName),
            archiveAction: .archiveAction(configuration: BuildTarget.dev.configurationName),
            profileAction: .profileAction(configuration: BuildTarget.dev.configurationName),
            analyzeAction: .analyzeAction(configuration: BuildTarget.dev.configurationName)
        ),
        .scheme(
            name: "App-prod",
            buildAction: .buildAction(targets: [.target(type.name)]),
            runAction: .runAction(configuration: BuildTarget.prod.configurationName),
            archiveAction: .archiveAction(configuration: BuildTarget.prod.configurationName),
            profileAction: .profileAction(configuration: BuildTarget.prod.configurationName),
            analyzeAction: .analyzeAction(configuration: BuildTarget.prod.configurationName)
        ),
    ]
)
