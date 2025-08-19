//
//  HomeViewModel.swift
//  Home
//
//  Created by ttozzi on 7/31/25.
//

import Combine
import DIInjector
import Foundation

protocol HomeCellModel {}

public final class HomeViewModel {

  enum Input {
    case viewDidLoad
    case recommendationButtonTapped(HomeRecommendationCollectionViewCellModel.State)
  }

  struct Output {
    let isLoading = CurrentValueSubject<Bool, Never>(false)
    let sections = CurrentValueSubject<[any HomeCellModel], Never>([])
  }

  @Injected var homeService: HomeService
  @Injected var homeRouter: HomeRouter
  let output: Output = Output()

  public init() {}

  func send(input: Input) {
    switch input {
    case .viewDidLoad:
      output.isLoading.send(true)
      Task {
        do {
          let sections = try await homeService.fetch()
          output.sections.send(sections)
        } catch {
          // TODO: 에러 처리
          print(error)
        }
        output.isLoading.send(false)
      }

    case .recommendationButtonTapped(let state):
      switch state {
      case .needsRecommendation:
        Task { @MainActor in
          homeRouter.navigate(
            to: HomeRoute.recommendationDetail, how: .push(hidesBottomBarWhenPushed: true),
            with: ["shouldCreateRecommendation": true])
        }

      case .recommended:
        Task { @MainActor in
          homeRouter.navigate(
            to: HomeRoute.recommendationDetail, how: .push(hidesBottomBarWhenPushed: true),
            with: ["shouldCreateRecommendation": false])
        }

      case .needsResultCheck:
        Task { @MainActor in
          homeRouter.navigate(
            to: HomeRoute.lottoResult, how: .push(hidesBottomBarWhenPushed: true),
            with: ["round": homeService.round as Any])
        }
      }
    }
  }
}
