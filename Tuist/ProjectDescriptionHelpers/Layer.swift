import ProjectDescription

public protocol Layer {
  
  var name: String { get }
  var options: Project.Options { get }
  var settings: Settings? { get }
  var targets: [Target] { get }
  var schemes: [Scheme] { get }
}

public extension Layer {
  
  var name: String { String(describing: Self.self) }
  var options: Project.Options { .options() }
  var schemes: [Scheme] { [] }
  var settings: Settings? { nil }
  var project: Project {
    return Project(
      name: name,
      options: options,
      settings: settings,
      targets: targets,
      schemes: schemes
    )
  }
}
