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
  case lottoResult
}

final class HomeRouter: Routable {
  // TODO: 생성 시점 data 주입을 위한 구조 논의 필요
  private var factories: [HomeRoute: ([String: Any]) -> UIViewController] = [:]

  public nonisolated init() {
    Task { @MainActor in
      self.setFactories()
    }
  }

  public func setFactories() {
    self.factories = [
      .recommendationLoading: { _ in
        return RecommendationLoadingViewController()
      },
      .recommendationDetail: { data in
        let shouldCreateRecommendation = data["shouldCreateRecommendation"] as? Bool
        return RecommendationDetailViewController(
          viewModel: RecommendationDetailViewModel(
            shouldCreateRecommendation: shouldCreateRecommendation ?? true))
      },
      .lottoResult: { _ in
        return LottoResultViewController(viewModel: LottoResultViewModel())
      },
    ]
  }

  public func navigate(to route: Any, how: NavigateType, with data: [String: Any]) {
    guard let homeRoute = route as? HomeRoute else { return }
    guard let factory = factories[homeRoute] else { return }
    let viewController = factory(data)
    manageViewController(viewController, how: how)
  }
}
