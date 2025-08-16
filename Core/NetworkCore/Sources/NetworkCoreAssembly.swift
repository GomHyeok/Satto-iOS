//
//  NetworkCoreAssembly.swift
//  NetworkCore
//
//  Created by ttozzi on 8/15/25.
//

import DIInjector
import Foundation

public final class NetworkCoreAssembly: Assembly {
  public func assemble(container: Container) {
    container.register(NetworkProvider.self) { _ in
      return NetworkProvider.shared
    }
  }

  public init() {}
}

