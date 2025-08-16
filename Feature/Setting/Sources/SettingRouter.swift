//
//  SettingRouter.swift
//  FeatureLayer
//
//  Created by 최재혁 on 8/16/25.
//

import Foundation
import Lib
import UIKit

public final class SettingRouter: Routable {
  private var factories: [SettingRoute: () -> UIViewController]

  public init() {
    self.factories = [:]
    self.setFactories()
  }

  public func setFactories() {
    self.factories = [
      .myPage: { MyPageViewController(viewModel: MyPageViewModel()) },
      .pushSetting: { PushSettingViewController(viewModel: PushSettingViewModel()) },
      .editProfile: { EditProfileViewController(router: self) },
    ]
  }

  public func navigate(to route: Any, how: NavigateType, with data: [String: Any]) {
    guard let settingRoute = route as? SettingRoute else { return }
    guard let factory = factories[settingRoute] else { return }
    let viewController = factory()

    manageViewController(viewController, how: how)
  }
}
