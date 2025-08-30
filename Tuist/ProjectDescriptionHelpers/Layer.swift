import ProjectDescription

public protocol Layer {

  var name: String { get }
  var options: Project.Options { get }
  var settings: Settings? { get }
  var targets: [Target] { get }
  var schemes: [Scheme] { get }
}

extension Layer {

  public var name: String { String(describing: Self.self) }
  public var options: Project.Options { .options() }
  public var schemes: [Scheme] { [] }
  public var settings: Settings? { nil }
  public var project: Project {
    return Project(
      name: name,
      options: options,
      settings: settings,
      targets: targets,
      schemes: schemes
    )
  }
}
