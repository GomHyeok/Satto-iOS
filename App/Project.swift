import ProjectDescription
import ProjectDescriptionHelpers

let project = AppLayer().project

struct AppLayer: Layer {
  
  var name: String { "Satto" }
  var targets: [Target] {
    [
      .createTarget(
        name: name,
        product: .app,
        bundleId: "com.hanbang.satto",
        infoPlist: .extendingDefault(
          with: [
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
        sources: ["Sources/**"],
        resources: ["Resources/**"],
        dependencies: [.project(target: "FeatureLayer", path: "../Feature")]
      )
    ]
  }
}
