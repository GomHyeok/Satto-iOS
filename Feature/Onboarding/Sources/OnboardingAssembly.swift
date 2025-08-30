//
//  OnboardingAssembly.swift
//  Onboarding
//
//  Created by ttozzi on 8/17/25.
//

import DIInjector
import Foundation

public final class OnboardingAssembly: Assembly {
  public func assemble(container: Container) {
    container.register(OnboardingRouter.self) { _ in
      return OnboardingRouter()
    }
  }

  public init() {}
}
