// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "BuildTools",
    platforms: [.macOS(.v10_15)],
    dependencies: [
        .package(url: "https://github.com/nicklockwood/SwiftFormat", .exact("0.49.5")),
        .package(url: "https://github.com/didix21/Shusky", from: "1.3.3"),
        .package(url: "https://github.com/realm/SwiftLint.git", from: "0.47.0"),
    ],
    targets: [.target(name: "BuildTools", path: "")]
)
