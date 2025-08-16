//
//  AppDelegate+Assembly.swift
//  Satto
//
//  Created by ttozzi on 8/15/25.
//

import Auth
import DIInjector
import Foundation
import Lib
import NetworkCore
import Setting

extension AppDelegate {
  func dependencyInjection() {
    DependencyInjector.shared.assemble([
      SettingAssembly(),
      AuthAssembly(),
      NetworkCoreAssembly(),
      LibAssembly(),
    ])
  }
}
