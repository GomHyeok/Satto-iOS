//
//  AppDelegate+Assembly.swift
//  Satto
//
//  Created by ttozzi on 8/15/25.
//

import Auth
import DIInjector
import Fortune
import Foundation
import Lib
import NetworkCore
import Setting
import Onboarding

extension AppDelegate {
  func setupDependencyInjector() {
    DependencyInjector.shared.assemble([
      SettingAssembly(),
      AuthAssembly(),
      NetworkCoreAssembly(),
      LibAssembly(),
      FortuneAssembly(),
      OnboardingAssembly()
    ])
  }
}
