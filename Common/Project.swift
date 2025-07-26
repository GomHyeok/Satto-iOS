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
          .target(name: "Lib"),
          .project(target: "CoreLayer", path: "../Core"),
          .project(target: "DesignSystem", path: "../DesignSystem"),
        ]
      ),
      .createTarget(name: "Auth"),
      .createTarget(name: "Constant"),
      .createTarget(
        name: "Lib",
        dependencies: [
          .external(name: "Then"),
          .external(name: "SnapKit"),
        ]
      ),
    ]
  }
}
