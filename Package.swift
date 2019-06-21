// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "Steering",
    products: [
        .library(
            name: "Steering",
            targets: ["Steering"]),
    ],
    dependencies: [
        .package(url: "https://github.com/christianampe/tyre.git",
                 .branch("master"))
    ],
    targets: [
        .target(
            name: "Steering",
            dependencies: ["Tyre"]),
        .testTarget(
            name: "SteeringTests",
            dependencies: ["Steering"]),
    ]
)
