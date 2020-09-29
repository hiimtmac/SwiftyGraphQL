// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftyGraphQL",
    platforms: [
        .macOS(.v10_14), .iOS(.v11)
    ],
    products: [
        .library(name: "SwiftyGraphQL", targets: ["SwiftyGraphQL"])
    ],
    targets: [
        .target(name: "SwiftyGraphQL", dependencies: []),
        .testTarget(name: "SwiftyGraphQLTests", dependencies: ["SwiftyGraphQL"])
    ]
)
