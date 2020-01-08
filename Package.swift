// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftyGraphQL",
    platforms: [
        .macOS(.v10_14)
    ],
    products: [
        .library(name: "SwiftyGraphQL", targets: ["SwiftyGraphQL"])
    ],
    targets: [
        .target(name: "SwiftyGraphQL", dependencies: []),
        .testTarget(name: "SwiftyGraphQLTests", dependencies: ["SwiftyGraphQL"])
    ]
)
