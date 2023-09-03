// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "quilt-sdk",
    platforms: [.iOS(.v15)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "quilt-sdk",
            targets: ["quilt-sdk"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        // TODO: add healthkit here

    ],
    targets: [
        .target(
            name: "quilt-sdk",
            dependencies: [],
            resources: [Resource.process("Media.xcassets")]
        ),
        .testTarget(
            name: "quilt-sdkTests",
            dependencies: ["quilt-sdk"]),
    ]
)
