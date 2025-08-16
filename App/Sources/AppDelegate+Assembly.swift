//
//  AppDelegate+Assembly.swift
//  Satto
//
//  Created by ttozzi on 8/15/25.
//

import Foundation
import DIInjector
import Setting
import Auth
import NetworkCore
import Lib

extension AppDelegate {
  func dependencyInjection() {
    DependencyInjector.shared.assemble([
      SettingAssembly(),
      AuthAssembly(),
      NetworkCoreAssembly(),
      LibAssembly()
    ])
  }
}
