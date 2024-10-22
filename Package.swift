// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "OutlineTextfield",
    platforms: [.iOS(.v13)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "OutlineTextfield",
            targets: ["OutlineTextfield"]),
    ],
    targets: [
        .target(
            name: "OutlineTextfield",
            dependencies: []
        ),
    ]
)
