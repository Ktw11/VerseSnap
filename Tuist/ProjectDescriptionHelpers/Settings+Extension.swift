import ProjectDescription

public extension ProjectDescription.Settings {
    static let commonModule: ProjectDescription.Settings = .settings(
        base: Settings.baseSettings,
        configurations: Configuration.common
    )
}

private extension ProjectDescription.Settings {
    static let baseSettings: SettingsDictionary = [
        "MARKETING_VERSION": "1.0.0",
        "CURRENT_PROJECT_VERSION": "1",
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
