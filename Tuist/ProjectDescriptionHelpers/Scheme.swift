import ProjectDescription

public extension Scheme {
    static func debug(name: String) -> Scheme {
        .scheme(
            name: name,
            buildAction: .buildAction(targets: [.target(name)]),
            runAction: .runAction(configuration: BuildTarget.dev.configurationName)
        )
    }
}
