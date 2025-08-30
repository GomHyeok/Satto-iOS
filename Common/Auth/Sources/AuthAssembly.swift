//
//  AuthAssembly.swift
//  Auth
//
//  Created by ttozzi on 8/15/25.
//

import DIInjector
import Foundation

public final class AuthAssembly: Assembly {
  public func assemble(container: Container) {
    container.register(DeviceUUIDManager.self) { _ in
      return DeviceUUIDManager.shared
    }
    container.register(UserDataManager.self) { _ in
      return UserDataManager.shared
    }
  }

  public init() {}
}
