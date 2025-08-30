//
//  SplashViewModel.swift
//  FeatureLayer
//
//  Created by 최재혁 on 7/23/25.
//

import Combine
import DIInjector
import Foundation
import Lib

public final class SplashViewModel {
  enum Input {
    case startButtonTap
  }

  struct Output {
    let navigate = PassthroughSubject<OnboardingRoute, Never>()
  }

  private var store: [AnyCancellable] = []

  let output: Output = .init()

  public init() {}

  func send(input: Input) {
    switch input {
    case .startButtonTap:
      self.output.navigate.send(.onboarding)
    }
  }
}
