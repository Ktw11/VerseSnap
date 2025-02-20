import ProjectDescription

extension Project {
    public static func target(
        type: TargetType,
        product: Product,
        infoPlist: InfoPlist? = nil,
        sources: SourceFilesList?,
        resources: ResourceFileElements? = nil,
        dependencies: [TargetDependency] = []
    ) -> Target {
        let baseSettings = SettingsDictionary()
        return Target.target(
            name: type.name,
            destinations: .iOS,
            product: product,
            bundleId: type.bundleId,
            infoPlist: infoPlist,
            sources: sources,
            resources: resources ?? [],
            dependencies: dependencies
        )
    }
}
