import ProjectDescription
import ProjectDescriptionHelpers

let project = AppLayer().project

struct AppLayer: Layer {
  
  var name: String { "Satto" }
  var options: Project.Options { .options(automaticSchemesOptions: .disabled) }
  var targets: [Target] {
    [
      .createTarget(
        name: name,
        product: .app,
        bundleId: "com.hanbang.satto",
        infoPlist: .extendingDefault(
          with: [
            "CFBundleDisplayName": "$(APP_NAME)",
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
        sources: ["Sources/**"],
        resources: ["Resources/**"],
        dependencies: [.project(target: "FeatureLayer", path: "../Feature")],
        settings: .settings(
          base: [
            "PRODUCT_BUNDLE_IDENTIFIER": "$(APP_IDENTIFIER)"
          ],
          configurations: [
            .debug(
              name: .debug,
              settings: [
                "APP_IDENTIFIER": "com.hanbang.satto.debug",
                "APP_NAME": "Satto Debug",
                "OTHER_SWIFT_FLAGS": "$(inherited) -DDEBUG"
              ]
            ),
            .release(
              name: .release,
              settings: [
                "APP_IDENTIFIER": "com.hanbang.satto",
                "APP_NAME": "Satto",
                "OTHER_SWIFT_FLAGS": "$(inherited) -DRELEASE"
              ]
            ),
          ]
        )
      )
    ]
  }
  var schemes: [Scheme] {
    [
      .scheme(
        name: "\(name)-debug",
        buildAction: .buildAction(targets: [.project(path: "./", target: name)]),
        runAction: .runAction(configuration: .debug),
        archiveAction: .archiveAction(configuration: .debug),
        profileAction: .profileAction(configuration: .debug),
        analyzeAction: .analyzeAction(configuration: .debug)
      ),
      .scheme(
        name: "\(name)-release",
        buildAction: .buildAction(targets: [.project(path: "./", target: name)]),
        runAction: .runAction(configuration: .release),
        archiveAction: .archiveAction(configuration: .release),
        profileAction: .profileAction(configuration: .release),
        analyzeAction: .analyzeAction(configuration: .release)
      ),
    ]
  }
}
