import ProjectDescription
import ProjectDescriptionHelpers

let project = FeatureLayer().project

struct FeatureLayer: Layer {

  var targets: [Target] {
    [
      .createTarget(
        name: name,
        sources: .empty,
        dependencies: [
          .target(name: "Onboarding"),
          .target(name: "Home"),
          .target(name: "Setting"),
          .target(name: "History"),
          .target(name: "Fortune"),
          .project(target: "CommonLayer", path: "../Common"),
        ]
      ),
      .createTarget(name: "Onboarding"),
      .createTarget(name: "Home"),
      .createTarget(name: "Setting"),
      .createTarget(name: "History"),
      .createTarget(name: "Fortune"),
    ]
  }
}
