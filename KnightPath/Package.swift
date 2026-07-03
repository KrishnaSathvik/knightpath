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
        .package(url: "https://github.com/chesskit-app/chesskit-swift", from: "1.3.0")
    ],
    targets: [
        .target(
            name: "KnightPath",
            dependencies: [
                .product(name: "ChessKit", package: "chesskit-swift")
            ]
        )
    ]
)
