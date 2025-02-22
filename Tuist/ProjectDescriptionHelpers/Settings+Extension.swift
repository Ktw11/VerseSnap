import ProjectDescription

public extension ProjectDescription.Settings {
    static let commonModule: ProjectDescription.Settings = .settings(
        base: Settings.baseSettings,
        configurations: [
            .debug(name: .dev, xcconfig: .relativeToRoot("Configs/\(BuildTarget.dev.name).xcconfig")),
            .release(name: .prod, xcconfig: .relativeToRoot("Configs/\(BuildTarget.prod.name).xcconfig"))
        ]
    )
}

private extension ProjectDescription.Settings {
    static let baseSettings: SettingsDictionary = [
        "IPHONEOS_DEPLOYMENT_TARGET": "18.0",
        "SWIFT_VERSION": "6.0",
        "SWIFT_STRICT_CONCURRENCY": "complete",
        "CODE_SIGN_IDENTITY": "Apple Development",
        "DEVELOPMENT_TEAM": "$(DEV_TEAM_ID)",
        "PROVISIONING_PROFILE_SPECIFIER": "",
        "CODE_SIGN_STYLE": "Automatic",
        "ENABLE_TESTABILITY": "YES",
        "SWIFT_EMIT_LOC_STRINGS": "YES"
    ]
}
