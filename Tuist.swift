import ProjectDescription

let config = Config(
    project: .tuist(
        compatibleXcodeVersions: .upToNextMajor("16.0"),
        plugins: [],
        generationOptions: .options(),
        installOptions: .options()
    )
)
