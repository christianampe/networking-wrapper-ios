// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "Steering",
    products: [
        .library(
            name: "Steering",
            targets: ["Steering"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Steering",
            dependencies: []),
        .testTarget(
            name: "SteeringTests",
            dependencies: ["Steering"]),
    ]
)
