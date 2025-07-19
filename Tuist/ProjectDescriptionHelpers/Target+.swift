import ProjectDescription

public extension Target {
  
  static func createTarget(
    name: String,
    product: Product = .staticFramework,
    bundleId: String? = nil,
    infoPlist: InfoPlist? = .default,
    sources: SourceFilesList? = nil,
    resources: ResourceFileElements? = nil,
    dependencies: [TargetDependency] = [],
    settings: ProjectDescription.Settings? = nil
  ) -> Self {
    return .target(
      name: name,
      destinations: .iOS,
      product: product,
      bundleId: bundleId ?? "com.hanbang.satto.\(name.lowercased())",
      deploymentTargets: .iOS("16.0"),
      infoPlist: infoPlist,
      sources: sources ?? ["\(name)/Sources/**"],
      resources: resources,
      dependencies: dependencies,
      settings: settings
    )
  }
}

public extension SourceFilesList {
  static var empty: Self { [] }
}
