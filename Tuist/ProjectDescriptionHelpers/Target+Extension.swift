import ProjectDescription

public extension Target {
    static func commonTarget(
        type: TargetType,
        product: Product,
        infoPlist: InfoPlist? = nil,
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
            infoPlist: infoPlist ?? .extendingDefault(with: [
                "CFBundleAllowMixedLocalizations": true
            ]),
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
    
    static func testTarget(
        type: TargetType,
        dependencies: [ProjectDescription.TargetDependency] = [],
    ) -> Target {
        var dependencies = dependencies
        dependencies.append(.target(name: type.name))
        dependencies.append(.xctest)
        
        return Target.target(
            name: "\(type.name)Tests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: type.testBundleId,
            sources: [
                "Tests/**"
            ],
            dependencies: dependencies
        )
    }
}
