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
          .target(name: "Base"),
          .target(name: "Constant"),
          .target(name: "Lib"),
          .project(target: "CoreLayer", path: "../Core"),
        ],
        settings: .settings(
          base: [
            "DEFINES_MODULE": "NO",
            "SWIFT_INSTALL_OBJC_HEADER": "NO",
          ]
        )
      ),
      .createTarget(
        name: "Auth",
        dependencies: [
          .target(name: "Lib")
        ]
      ),
      .createTarget(
        name: "Base",
        dependencies: [
          .project(target: "DesignSystem", path: "../DesignSystem"),
          .external(name: "Then"),
          .external(name: "SnapKit"),
        ]
      ),
      .createTarget(name: "Constant"),
      .createTarget(
        name: "Lib",
        dependencies: [
          .external(name: "Then"),
          .external(name: "SnapKit"),
        ]
      ),
      .createTarget(
        name: "LibTest",
        product: .app,
        infoPlist: .extendingDefault(
          with: [
            "UILaunchStoryboardName": "LaunchScreen",
            "UIApplicationSceneManifest": [
              "UIApplicationSupportsMultipleScenes": false,
              "UISceneConfigurations": [
                "UIWindowSceneSessionRoleApplication": [
                  [
                    "UISceneConfigurationName": "Default Configuration",
                    "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate",
                  ]
                ]
              ],
            ],
          ]
        ),
        sources: ["LibTest/Sources/**"],
        dependencies: [
          .target(name: "Lib")
        ]
      ),
    ]
  }
}
