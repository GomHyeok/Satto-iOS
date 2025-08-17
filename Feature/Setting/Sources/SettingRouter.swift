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
  private var factories: [SettingRoute: () -> UIViewController] = [:]
  
  public nonisolated init() {
    Task { @MainActor in
      self.setFactories()
    }
  }

  public func setFactories() {
    self.factories = [
      .myPage: { MyPageViewController(viewModel: MyPageViewModel()) },
      .pushSetting: { PushSettingViewController(viewModel: PushSettingViewModel()) },
      .editProfile: { EditProfileViewController() },
      .timePicker: { TimePickerBottomSheetViewController()}
    ]
  }

  public func navigate(to route: Any, how: NavigateType, with data: [String: Any]) {
    guard let settingRoute = route as? SettingRoute else { return }
    guard let factory = factories[settingRoute] else { return }
    let viewController = factory()

    if settingRoute == .timePicker {
      if let timePickerVC = viewController as? TimePickerBottomSheetViewController,
        let delegate = data["delegate"] as? TimePickerBottomSheetDelegate
      {
        timePickerVC.delegate = delegate
      }
    }
    manageViewController(viewController, how: how)
  }
}
