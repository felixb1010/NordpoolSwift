// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Nordpool",
    platforms: [
        .iOS(.v13), .macOS(.v12), .watchOS(.v8), .macCatalyst(.v13), .tvOS(.v13)
    ],
    products: [
        .library(
            name: "Nordpool",
            targets: ["Nordpool"]),
        .executable(name: "NordpoolExec", targets: ["NordpoolExec"])
    ],
    targets: [
        .target(
            name: "Nordpool",
            dependencies: []),
        .executableTarget(name: "NordpoolExec", dependencies: ["Nordpool"]),
        .testTarget(
            name: "NordpoolTests",
            dependencies: ["Nordpool"]),
    ]
)
