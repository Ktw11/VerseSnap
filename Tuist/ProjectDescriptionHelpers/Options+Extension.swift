import ProjectDescription

public extension Project.Options {
    static func commonOptions(
        automaticSchemesOptions: Project.Options.AutomaticSchemesOptions? = nil
    ) -> Self {
        .options(
            automaticSchemesOptions: automaticSchemesOptions ?? .enabled(),
            defaultKnownRegions: ["en", "ko"],
            developmentRegion: "ko"
        )
    }
}
