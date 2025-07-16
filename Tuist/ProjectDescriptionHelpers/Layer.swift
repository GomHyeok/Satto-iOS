import ProjectDescription

public protocol Layer {
  
  var name: String { get }
  var targets: [Target] { get }
}

public extension Layer {
  
  var name: String { String(describing: Self.self) }
  var project: Project {
    return Project(name: name, targets: targets)
  }
}
