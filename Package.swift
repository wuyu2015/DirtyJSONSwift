// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DirtyJSON",
    platforms: [
        .macOS(.v10_10),
        .iOS(.v8),
        .tvOS(.v9),
        .watchOS(.v2)
    ],
    products: [
        .library(
            name: "DirtyJSON",
            targets: ["DirtyJSON"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "DirtyJSON",
            dependencies: []),
        .testTarget(
            name: "DirtyJSONTests",
            dependencies: ["DirtyJSON"]),
    ],
    swiftLanguageVersions: [.v5]
)
