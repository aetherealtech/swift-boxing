// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Boxing",
    products: [
        .library(
            name: "Boxing",
            targets: ["Boxing"]
        ),
    ],
    targets: [
        .target(
            name: "Boxing"
        ),
        .testTarget(
            name: "BoxingTests",
            dependencies: ["Boxing"]
        ),
    ]
)
