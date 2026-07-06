// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "KnightPath",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "KnightPath",
            targets: ["KnightPath"])
    ],
    dependencies: [
        .package(url: "https://github.com/chesskit-app/chesskit-swift", from: "1.3.0"),
        .package(url: "https://github.com/chesskit-app/chesskit-engine", from: "0.1.0"),
        .package(url: "https://github.com/airbnb/lottie-ios", from: "4.3.0")
    ],
    targets: [
        .target(
            name: "KnightPath",
            dependencies: [
                .product(name: "ChessKit", package: "chesskit-swift"),
                .product(name: "ChessKitEngine", package: "chesskit-engine"),
                .product(name: "Lottie", package: "lottie-ios")
            ]
        )
    ]
)
