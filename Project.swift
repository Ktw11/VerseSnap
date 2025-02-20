import ProjectDescription

let project = Project(
    name: "VerseSnap",
    targets: [
        .target(
            name: "VerseSnap",
            destinations: .iOS,
            product: .app,
            bundleId: "io.tuist.VerseSnap",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                ]
            ),
            sources: ["VerseSnap/Sources/**"],
            resources: ["VerseSnap/Resources/**"],
            dependencies: []
        ),
        .target(
            name: "VerseSnapTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.VerseSnapTests",
            infoPlist: .default,
            sources: ["VerseSnap/Tests/**"],
            resources: [],
            dependencies: [.target(name: "VerseSnap")]
        ),
    ]
)
