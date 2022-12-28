// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Nordpool",
    platforms: [
        .iOS(.v15), .watchOS(.v8), .macOS(.v12), .macCatalyst(.v15), .tvOS(.v15)
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
