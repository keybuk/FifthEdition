// swift-tools-version: 6.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import CompilerPluginSupport
import PackageDescription

let package = Package(
    name: "FifthEdition",
    defaultLocalization: "en",
    platforms: [
        .macOS(.v15),
    ],
    products: [
        .library(
            name: "FifthEdition",
            targets: ["FifthEdition"],
        ),
        .library(
            name: "FifthEditionUI",
            targets: ["FifthEditionUI"],
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-algorithms", from: "1.2.0"),
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.0.0"),
        .package(url: "https://github.com/swiftlang/swift-docc-plugin", from: "1.1.0"),
        .package(url: "https://github.com/swiftlang/swift-syntax", from: "600.0.0"),
        .package(url: "https://github.com/gohanlon/swift-memberwise-init-macro.git",
                 .upToNextMajor(from: "0.6.0")),
    ],
    targets: [
        .target(
            name: "FifthEdition",
            dependencies: [
                "FifthEditionMacros",
                .product(name: "Algorithms", package: "swift-algorithms"),
                .product(name: "MemberwiseInit", package: "swift-memberwise-init-macro"),
            ],
            resources: [
                .copy("FifthEdition.docc"),
                .copy("Localizable.xcstrings"),
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
        .target(
            name: "FifthEditionUI",
            dependencies: [
                "FifthEdition",
            ],
            resources: [
                .copy("FifthEditionUI.docc"),
                .copy("Localizable.xcstrings"),
            ],
        ),
        .executableTarget(
            name: "ParseTool",
            dependencies: [
                "FifthEdition",
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ],
        ),
    ],
)
