// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import CompilerPluginSupport
import PackageDescription

let package = Package(
    name: "FifthEdition",
    platforms: [
        .macOS(.v15),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "FifthEdition",
            targets: ["FifthEdition"],
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/swiftlang/swift-docc-plugin", from: "1.1.0"),
        .package(url: "https://github.com/swiftlang/swift-syntax", from: "600.0.0"),
        .package(url: "https://github.com/gohanlon/swift-memberwise-init-macro.git", .upToNextMajor(from: "0.6.0")),
        .package(url: "https://github.com/DnV1eX/EnumOptionSet.git", .upToNextMajor(from: "2.0.0")),
    ],
    targets: [
        .target(
            name: "FifthEdition",
            dependencies: [
                "FifthEditionMacros",
                "EnumOptionSet",
                .product(name: "MemberwiseInit", package: "swift-memberwise-init-macro"),
            ],
            resources: [
                .copy("FifthEdition.docc"),
            ],
        ),
        .testTarget(
            name: "FifthEditionTests",
            dependencies: ["FifthEdition"],
        ),
        .macro(
            name: "FifthEditionMacros",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
            ],
        ),
    ],
)
