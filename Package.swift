// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "MissionCompiler",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .library(name: "MissionCompilerCore", targets: ["MissionCompilerCore"]),
        .executable(name: "MissionCompiler", targets: ["MissionCompilerApp"])
    ],
    targets: [
        .target(name: "MissionCompilerCore"),
        .executableTarget(
            name: "MissionCompilerApp",
            dependencies: ["MissionCompilerCore"]
        ),
        .testTarget(
            name: "MissionCompilerCoreTests",
            dependencies: ["MissionCompilerCore"]
        )
    ]
)
