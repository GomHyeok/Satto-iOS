// swift-tools-version: 6.0
import PackageDescription

#if TUIST
import struct ProjectDescription.PackageSettings

let packageSettings = PackageSettings(
  productTypes: [
    "Moya": .staticFramework,
    "Then": .staticFramework,
    "SnapKit": .staticFramework,
    "Swinject": .staticFramework,
    "SwiftRichString": .staticFramework,
  ]
)
#endif

let package = Package(
  name: "Satto",
  dependencies: [
    .package(url: "https://github.com/Moya/Moya.git", from: "15.0.0"),
    .package(url: "https://github.com/devxoul/Then.git", from: "3.0.0"),
    .package(url: "https://github.com/SnapKit/SnapKit.git", from: "5.7.1"),
    .package(url: "https://github.com/Swinject/Swinject.git", from: "2.9.1"),
    .package(url: "https://github.com/malcommac/SwiftRichString.git", from: "3.7.2"),
  ]
)
