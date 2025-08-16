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
  private var factories: [OnboardingRoute: () -> UIViewController] = [:]

  public nonisolated init() {
    Task { @MainActor in
      self.setFactories()
    }
  }

  public func setFactories() {
    self.factories = [
      .splash: {
        let viewModel = SplashViewModel()
        return SplashViewcontroller(viewModel: viewModel, router: self)
      },
      .agreement: { AgreementViewController() },
      .onboarding: { OnboardingViewController(router: self) },
      .timePicker: { TimePickerBottomSheetViewController() },
    ]
  }

  public func navigate(to route: Any, how: NavigateType, with data: [String: Any]) {
    guard let onboardingRoute = route as? OnboardingRoute else { return }
    guard let factory = factories[onboardingRoute] else { return }
    let viewController = factory()

    if onboardingRoute == .agreement {
      if let agreementVC = viewController as? AgreementViewController,
        let delegate = data["delegate"] as? AgreementViewDelegate
      {
        agreementVC.delegate = delegate
      }
    } else if onboardingRoute == .timePicker {
      if let timePickerVC = viewController as? TimePickerBottomSheetViewController,
        let delegate = data["delegate"] as? TimePickerBottomSheetDelegate
      {
        timePickerVC.delegate = delegate
      }
    }

    manageViewController(viewController, how: how)
  }
}
