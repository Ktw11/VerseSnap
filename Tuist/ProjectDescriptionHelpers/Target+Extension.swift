import ProjectDescription

public extension Target {
    static func commonTarget(
        type: TargetType,
        product: Product,
        infoPlist: InfoPlist = .default,
        sources: SourceFilesList?,
        resources: ResourceFileElements? = nil,
        entitlements: Entitlements? = nil,
        dependencies: [TargetDependency] = []
    ) -> Target {
        Target.target(
            name: type.name,
            destinations: .iOS,
            product: product,
            bundleId: type.bundleId,
            infoPlist: infoPlist,
            sources: sources,
            resources: resources ?? [],
            entitlements: entitlements,
            dependencies: dependencies
        )
    }
    
    static func interfaceTarget(
        type: TargetType,
        product: Product,
        dependencies: [TargetDependency] = []
    ) -> Target {
        Target.target(
            name: type.interfaceName,
            destinations: .iOS,
            product: product,
            bundleId: type.interfaceBundleId,
            sources: ["Interfaces/**"],
            dependencies: dependencies
        )
    }
}
