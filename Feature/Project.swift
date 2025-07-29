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
          .project(target : "DesignSystem", path : "../DesignSystem")
        ],
        settings: .settings(
          base: [
            "DEFINES_MODULE": "NO",
            "SWIFT_INSTALL_OBJC_HEADER": "NO",
          ]
        )
      ),
      .createTarget(
        name: "Onboarding",
        dependencies: [
            .external(name: "SnapKit"),
        ]
      ),
      .createTarget(name: "Home"),
      .createTarget(
        name: "Setting",
        dependencies: [
          .project(target: "CommonLayer", path: "../Common"),
        ]
      ),
      .createTarget(name: "History"),
      .createTarget(name: "Fortune"),
    ]
  }
}
