import ProjectDescription
import ProjectDescriptionHelpers

let workspace = Workspace(
    name: "VerseSnap",
    projects: [
        "App",
        "Feature/**",
        "Domain/**",
        "Core/**",
        "Data/**",
        "Shared/**",
        "PreviewSupport/**"
    ]
)
