import ProjectDescription
import ProjectDescriptionHelpers

let project = DesignSystemLayer().project

struct DesignSystemLayer: Layer {
  
  var targets: [Target] {
    [
      .createTarget(
        name: "DesignSystem",
        sources: ["DesignSystem/Sources/**"],
        resources: ["DesignSystem/Resources/**"],
        dependencies: [
          .external(name: "SwiftRichString")
        ]
      ),
      .createTarget(
        name: "DesignSystemSample",
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
                    "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate"
                  ],
                ]
              ]
            ],
          ]
        ),
        sources: ["Sample/Sources/**"],
        dependencies: [
          .target(name: "DesignSystem")
        ]
      )
    ]
  }
}
