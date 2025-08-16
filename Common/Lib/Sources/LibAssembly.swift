//
//  LibAssembly.swift
//  Lib
//
//  Created by 최재혁 on 7/23/25.
//

import DIInjector
import Foundation

public final class LibAssembly: Assembly {
  public func assemble(container: Container) {
    container.register(DependencyHandler.self) { _ in
      return DependencyHandler.shared
    }
  }

  public init() {}
}
