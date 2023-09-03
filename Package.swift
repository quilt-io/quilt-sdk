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
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "quilt-sdk",
            dependencies: [],
            resources: [.process("Resources")]
        ),
        .testTarget(
            name: "quilt-sdkTests",
            dependencies: ["quilt-sdk"]),
    ]
)
