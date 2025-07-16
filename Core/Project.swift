import ProjectDescription
import ProjectDescriptionHelpers

let project = CoreLayer().project

struct CoreLayer: Layer {
  
  var targets: [Target] {
    [
      .createTarget(
        name: "CoreLayer",
        sources: .empty,
        dependencies: [
          .target(name: "NetworkCore"),
          .target(name: "DIInjector")
        ]
      ),
      .createTarget(name: "NetworkCore"),
      .createTarget(name: "DIInjector")
    ]
  }
}
