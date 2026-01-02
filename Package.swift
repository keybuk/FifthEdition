// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FifthEdition",
    platforms: [
        .macOS(.v13),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "FifthEdition",
            targets: ["FifthEdition"],
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/gohanlon/swift-memberwise-init-macro.git", .upToNextMajor(from: "0.5.1")),
        .package(url: "https://github.com/DnV1eX/EnumOptionSet.git", .upToNextMajor(from: "2.0.0")),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "FifthEdition",
            dependencies: [
                "EnumOptionSet",
                .product(name: "MemberwiseInit", package: "swift-memberwise-init-macro"),
            ],
        ),
        .testTarget(
            name: "FifthEditionTests",
            dependencies: ["FifthEdition"],
            resources: [
                .copy("Resources/releases.json"),
                .copy("Resources/example.zip"),
                .copy("Resources/bad_example.zip"),
            ],
        ),
    ],
)
