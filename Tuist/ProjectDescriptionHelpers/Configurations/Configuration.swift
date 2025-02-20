import ProjectDescription

public extension ConfigurationName {
    static var dev: ConfigurationName { configuration(BuildTarget.dev.name) }
    static var prod: ConfigurationName { configuration(BuildTarget.prod.name) }
}
