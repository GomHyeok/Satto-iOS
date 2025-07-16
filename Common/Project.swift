import ProjectDescription
import ProjectDescriptionHelpers

let project = CommonLayer().project

struct CommonLayer: Layer {
  
  var targets: [Target] {
    [
      .createTarget(
        name: name,
        sources: .empty,
        dependencies: [
          .target(name: "Auth"),
          .target(name: "Constant"),
          .target(name: "DesignSystem"),
          .target(name: "Lib"),
          .project(target: "CoreLayer", path: "../Core")
        ]
      ),
      .createTarget(name: "Auth"),
      .createTarget(name: "Constant"),
      .createTarget(name: "DesignSystem"),
      .createTarget(name: "Lib"),
    ]
  }
}
