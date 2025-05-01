import ProjectDescription

public extension TargetDependency {
    static func feature(type: TargetType) -> TargetDependency {
        .project(target: type.name, path: .relativeToRoot("Feature/\(type.name)"))
    }
    
    static func featureInterface(type: TargetType) -> TargetDependency {
        .project(target: type.interfaceName, path: .relativeToRoot("Feature/\(type.name)"))
    }
    
    static var domain: TargetDependency {
        .project(target: TargetType.domain.name, path: .relativeToRoot("Domain"))
    }
    
    static func core(type: TargetType) -> TargetDependency {
        .project(target: type.name, path: .relativeToRoot("Core/\(type.name)"))
    }

    static func data(type: TargetType) -> TargetDependency {
        .project(target: type.name, path: .relativeToRoot("Data/\(type.name)"))
    }
    
    static func shared(type: TargetType) -> TargetDependency {
        .project(target: type.name, path: .relativeToRoot("Shared/\(type.name)"))
    }
    
    static var previewSupport: TargetDependency {
        .project(target: TargetType.previewSupport.name, path: .relativeToRoot("PreviewSupport"))
    }
}
