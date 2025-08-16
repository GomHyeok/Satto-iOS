//
//  AppDelegate+DependencyHandler.swift
//  Satto
//
//  Created by ttozzi on 8/16/25.
//

import Foundation
import Lib

extension AppDelegate {
  func setupDependencyHandler() {
    DependencyHandler.shared.register(dependencies: [
      AppDependencyHandler()
    ])
  }
}
