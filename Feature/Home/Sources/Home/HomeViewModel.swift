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
    let sections = CurrentValueSubject<[any HomeCellModel], Never>([])
  }

  @Injected var homeService: HomeService
  @Injected var homeRouter: HomeRouter
  let output: Output = Output()

  public init() {}

  func send(input: Input) {
    switch input {
    case .viewDidLoad:
      Task {
        do {
          let sections = try await homeService.fetch()
          output.sections.send(sections)
        } catch {
          // TODO: 에러 처리
          print(error)
        }
      }

    case .recommendationButtonTapped(let state):
      switch state {
      case .needsRecommendation:
        Task { @MainActor in
          homeRouter.navigate(
            to: HomeRoute.recommendationLoading, how: .push(hidesBottomBarWhenPushed: true),
            with: [:])
        }
      case .recommended:
        // TODO: 번호 상세
        break
      case .needsResultCheck:
        // TODO: 결과
        break
      }
    }
  }
}
