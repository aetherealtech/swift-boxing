// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Boxing",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Boxing",
            targets: ["Boxing"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Boxing"),
        .testTarget(
            name: "BoxingTests",
            dependencies: ["Boxing"]
        ),
    ]
)
