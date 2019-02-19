// swift-tools-version:4.2

import PackageDescription

let package = Package(
    name: "MarionetteJS",
    products: [
        .library(name: "MarionetteJS", type: .dynamic, targets: ["MarionetteTrampoline", "MarionetteJS"]),
    ],
    dependencies: [
        .package(url: "https://github.com/LinusU/Marionette", from: "1.0.0-alpha.10"),
        .package(url: "https://github.com/LinusU/swift-napi-bindings", from: "1.0.0-alpha.3"),
    ],
    targets: [
        .target(name: "MarionetteTrampoline", dependencies: ["NAPIC", "NAPI"], path: "Sources/MarionetteTrampoline"),
        .target(name: "MarionetteJS", dependencies: ["NAPIC", "NAPI", "Marionette", "MarionetteTrampoline"], path: "Sources/MarionetteJS"),
    ]
)
