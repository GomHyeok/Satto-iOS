//
//  DependencyHandler.swift
//  Lib
//
//  Created by ttozzi on 8/16/25.
//

import Foundation

public final class DependencyHandler {

  public static let shared = DependencyHandler()

  private var handlers: [String: () -> Void] = [:]

  private init() {}

  public func register(dependencies: [any DependencyRegistrable]) {
    dependencies.forEach {
      $0.register(to: self)
    }
  }

  public func register(key: String, handler: @escaping () -> Void) {
    handlers[key] = handler
  }

  public func handle(key: String) {
    handlers[key]?()
  }
}

public protocol DependencyRegistrable {
  func register(to dependencyHandler: DependencyHandler)
}
