// swift-tools-version:4.2
import PackageDescription

let package = Package(
    name: "Bagel",
    products: [
        .library(name: "Bagel", targets: ["Bagel"])
    ],
    dependencies: [
        .package(url: "https://github.com/robbiehanson/CocoaAsyncSocket.git", .upToNextMajor(from: "7.6.4")),
    ],
    targets: [
        .target(
            name: "Bagel",
            dependencies: ["CocoaAsyncSocket"],
            path: "iOS/Source",
            publicHeadersPath: ""
        )
    ]
)
