//
//  HomeViewModel.swift
//  Home
//
//  Created by ttozzi on 7/31/25.
//

import Auth
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
  @Injected var userDataManager: UserDataManager

  let output: Output = Output()
  private var cancellables = Set<AnyCancellable>()

  public init() {
    userDataManager
      .getPublisher()
      .sink { [weak self] _ in
        guard let self = self else { return }
        fetch()
      }
      .store(in: &cancellables)

    homeService
      .recommendationStateChanged
      .sink { [weak self] _ in
        guard let self = self else { return }
        fetchRecommendation()
      }
      .store(in: &cancellables)
  }

  func send(input: Input) {
    switch input {
    case .viewDidLoad:
      fetch()

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

extension HomeViewModel {
  fileprivate func fetch() {
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
  }

  fileprivate func fetchRecommendation() {
    output.isLoading.send(true)
    Task {
      do {
        let sections = try await homeService.fetchLottoRecommendation()
        output.sections.send(sections)
      } catch {
        // TODO: 에러 처리
        print(error)
      }
      output.isLoading.send(false)
    }
  }
}
