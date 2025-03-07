import ProjectDescription
import ProjectDescriptionHelpers

let type = TargetType.app

let project = Project(
    name: type.name,
    options: .commonOptions(automaticSchemesOptions: .disabled),
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
                    "KakaoAppKey": "$(KAKAO_APP_KEY)",
                    "BaseURL": "$(API_BASE_URL)",
                    "LSApplicationQueriesSchemes": [
                        "kakaokompassauth"
                    ]
                ]
            ),
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            entitlements: .file(path: .relativeToManifest("VerseSnap.entitlements")),
            dependencies: [
                .feature(type: .signIn),
                .core(type: .thirdPartyAuth),
                .data(type: .repository),
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
