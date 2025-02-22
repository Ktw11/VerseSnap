import ProjectDescription

public extension TargetDependency {
    static func feature(type: TargetType) -> TargetDependency {
        .project(target: type.name, path: .relativeToRoot("Feature/\(type.name)"))
    }
}

