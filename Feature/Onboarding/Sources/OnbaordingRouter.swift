//
//  OnbaordingRouter.swift
//  CommonLayer
//
//  Created by 최재혁 on 8/2/25.
//

import Foundation
import Lib
import UIKit

public final class OnboardingRouter: Routable {
  private var factories: [OnboardingRoute: () -> UIViewController]

  public init() {
    self.factories = [
      .splash: { SplashViewcontroller() },
      .agreement: { AgreementViewController() },
      .onboarding: { OnboardingViewController() },
      .timePicker: { TimePickerBottomSheetViewController() },
    ]
  }

  public func navigate(to route: Any, how: NavigateType, with data: [String: Any]) {
    guard let onboardingRoute = route as? OnboardingRoute else { return }
    guard let factory = factories[onboardingRoute] else { return }
    let viewController = factory()

    manageViewController(viewController, how: how)
  }
}
