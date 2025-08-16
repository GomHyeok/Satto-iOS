//
//  AppDependencyHandler.swift
//  Satto
//
//  Created by ttozzi on 8/16/25.
//

import Base
import Fortune
import Foundation
import History
import Home
import Lib
import Setting
import UIKit

struct AppDependencyHandler: DependencyRegistrable {
  func register(to dependencyHandler: DependencyHandler) {
    dependencyHandler.register(key: DependencyKey.App.configureTabBarController) {
      Task { @MainActor in
        self.configureTabBarController()
      }
    }
  }

  private func configureTabBarController() {
    // TODO: 이미 TabBarController 가 있는 경우에 대한 예외 처리
    let tabBarController = BaseTabBarController()
    tabBarController.viewControllers = [
      HomeViewController(viewModel: HomeViewModel()),
      FortuneViewController(viewModel: FortuneViewModel()),
      HistoryWebViewController(viewModel: HistoryWebViewModel()),
      MyPageViewController(viewModel: MyPageViewModel()),
    ]
    UIApplication.shared.activeWindow?.rootViewController = tabBarController
  }
}

extension UIApplication {
  fileprivate var activeWindow: UIWindow? {
    return
      connectedScenes
      .compactMap { $0 as? UIWindowScene }
      .flatMap { $0.windows }
      .first { $0.isKeyWindow }
  }
}
