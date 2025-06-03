import ProjectDescription
import ProjectDescriptionHelpers

let type = TargetType.verseSnap

let project = Project(
    name: type.name,
    options: .commonOptions(automaticSchemesOptions: .disabled),
    settings: .commonModule,
    targets: [
        Target.commonTarget(
            type: type,
            product: .app,
            productName: type.name,
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "LaunchScreenColor",
                        "UIImageName": "",
                    ],
                    "CFBundleDisplayName": "VerseSnap",
                    "KakaoAppKey": "$(KAKAO_APP_KEY)",
                    "BaseURL": "$(API_BASE_URL)",
                    "LSApplicationQueriesSchemes": [
                        "kakaokompassauth"
                    ],
                    "CFBundleURLTypes": [
                        [
                            "CFBundleURLSchemes": [
                                "kakao$(KAKAO_APP_KEY)"
                            ]
                        ]
                    ],
                    "NSPhotoLibraryUsageDescription": "Permission to access your photo library is required to use the acrostic poem generation feature. You can change this in Settings.",
                    "UISupportedInterfaceOrientations": [
                        "UIInterfaceOrientationPortrait"
                    ]
                ]
            ),
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            entitlements: .file(path: .relativeToManifest("VerseSnap.entitlements")),
            dependencies: [
                .feature(type: .signIn),
                .feature(type: .home),
                .feature(type: .newVerse),
                .feature(type: .selectPhoto),
                .feature(type: .profile),
                .core(type: .thirdPartyAuth),
                .core(type: .remoteStorage),
                .data(type: .repository),
                .shared(type: .commonUI),
                .shared(type: .utils),
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
