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
          .target(name: "DIInjector"),
          .target(name: "Extension"),
        ],
        settings: .settings(
          base: [
            "DEFINES_MODULE": "NO",
            "SWIFT_INSTALL_OBJC_HEADER": "NO",
          ]
        )
      ),
      .createTarget(
        name: "NetworkCore",
        dependencies: [
          .external(name: "Moya")
        ]
      ),
      .createTarget(
        name: "DIInjector",
        dependencies: [
          .external(name: "Swinject")
        ]
      ),
      .createTarget(
        name: "DITest",
        product: .unitTests,
        sources: ["DIInjector/Test/Sources/**"],
        dependencies: [
          .target(name: "DIInjector")

        ]
      ),
      .createTarget(
        name: "Extension"
      ),
    ]
  }
}
