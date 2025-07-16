import ProjectDescription

public extension Target {
  
  static func createTarget(
    name: String,
    product: Product = .staticFramework,
    bundleId: String? = nil,
    infoPlist: InfoPlist? = .default,
    sources: SourceFilesList? = nil,
    resources: ResourceFileElements? = nil,
    dependencies: [TargetDependency] = []
  ) -> Self {
    return .target(
      name: name,
      destinations: .iOS,
      product: product,
      bundleId: bundleId ?? "com.hanbang.satto.\(name.lowercased())",
      infoPlist: infoPlist,
      sources: sources ?? ["\(name)/Sources/**"],
      resources: resources,
      dependencies: dependencies
    )
  }
}

public extension SourceFilesList {
  static var empty: Self { [] }
}
