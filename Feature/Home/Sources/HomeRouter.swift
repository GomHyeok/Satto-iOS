//
//  HomeRouter.swift
//  Home
//
//  Created by ttozzi on 8/17/25.
//

import Lib
import UIKit

enum HomeRoute {
  case recommendationLoading
  case recommendationDetail
}

final class HomeRouter: Routable {
  private var factories: [HomeRoute: () -> UIViewController] = [:]

  public nonisolated init() {
    Task { @MainActor in
      self.setFactories()
    }
  }

  public func setFactories() {
    self.factories = [
      .recommendationLoading: {
        return RecommendationLoadingViewController()
      },
      .recommendationDetail: {
        return RecommendationDetailViewController(viewModel: RecommendationDetailViewModel())
      }
    ]
  }

  public func navigate(to route: Any, how: NavigateType, with data: [String: Any]) {
    guard let homeRoute = route as? HomeRoute else { return }
    guard let factory = factories[homeRoute] else { return }
    let viewController = factory()
    manageViewController(viewController, how: how)
  }
}
