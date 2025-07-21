// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "IvanCantarino",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        .executable(
            name: "IvanCantarino",
            targets: ["IvanCantarino"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/johnsundell/publish.git", from: "0.9.0"),
        .package(url: "https://github.com/johnsundell/splashpublishplugin", from: "0.1.0")
    ],
    targets: [
        .executableTarget(
            name: "IvanCantarino",
            dependencies: [
                .product(name: "Publish", package: "publish"),
                .product(name: "SplashPublishPlugin", package: "splashpublishplugin")
            ]
        )
    ]
)
