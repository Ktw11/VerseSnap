import ProjectDescription

public extension ConfigurationName {
    static var dev: ConfigurationName { configuration(BuildTarget.dev.name) }
    static var prod: ConfigurationName { configuration(BuildTarget.prod.name) }
}

public extension Configuration {
    static let common: [Configuration] = [
        .debug(name: .dev, xcconfig: .relativeToRoot("Configs/\(BuildTarget.dev.name).xcconfig")),
        .release(name: .prod, xcconfig: .relativeToRoot("Configs/\(BuildTarget.prod.name).xcconfig"))
    ]
}
