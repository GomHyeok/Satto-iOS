//
//  SettingAssembly.swift
//  Setting
//
//  Created by ttozzi on 8/1/25.
//

import DIInjector
import Foundation

public final class SettingAssembly: Assembly {
  public func assemble(container: Container) {
    container.register(MyPageService.self) { _ in
      return MyPageService()
    }
  }

  public init() {}
}
