//
//  RecommendationDetailViewModel.swift
//  Home
//
//  Created by ttozzi on 8/9/25.
//

import Combine
import DIInjector
import DesignSystem
import Foundation

protocol RecommendationDetailCellModel {}

final class RecommendationDetailViewModel {

  enum Constant {
    static let minimumLoadingDuration: TimeInterval = 2.0
  }

  enum Input {
    case viewDidLoad
    case timerFinished
    case createNewRecommendationButtonTapped
    case showResultsButtonTapped
    case backButtonTapped
  }

  struct Output {
    let isRecommendationLoading = CurrentValueSubject<Bool, Never>(false)
    let navigationTitle = CurrentValueSubject<String?, Never>(nil)
    let sections = CurrentValueSubject<[any RecommendationDetailCellModel], Never>([])
    let isResultAvailable = CurrentValueSubject<Bool, Never>(false)
    let back = PassthroughSubject<Void, Never>()
  }

  @Injected var recommendationDetailService: RecommendationDetailService
  @Injected var homeRouter: HomeRouter
  let output: Output = Output()
  private let shouldCreateRecommendation: Bool

  init(shouldCreateRecommendation: Bool) {
    self.shouldCreateRecommendation = shouldCreateRecommendation
  }

  func send(input: Input) {
    switch input {
    case .viewDidLoad:
      output.navigationTitle.send(recommendationDetailService.navigationTitle)
      Task {
        do {
          // TODO: 로딩 인디케이터
          if shouldCreateRecommendation {
            async let minDelay: Void = Task.sleep(for: .seconds(Constant.minimumLoadingDuration))
            output.isRecommendationLoading.send(true)
            let sections = try await recommendationDetailService.createRecommendation()
            _ = try? await minDelay
            output.sections.send(sections)
            output.isRecommendationLoading.send(false)
          } else {
            let sections = try await recommendationDetailService.fetchRecommendation()
            output.sections.send(sections)
          }
        } catch {
          // TODO: 에러 처리
          output.isRecommendationLoading.send(false)
          print(error)
        }
      }

    case .timerFinished:
      output.isResultAvailable.send(true)

    case .createNewRecommendationButtonTapped:
      Task {
        do {
          async let minDelay: Void = Task.sleep(for: .seconds(Constant.minimumLoadingDuration))
          output.isRecommendationLoading.send(true)
          let sections = try await recommendationDetailService.createRecommendation()
          _ = try? await minDelay
          output.sections.send(sections)
          output.isRecommendationLoading.send(false)
        } catch {
          // TODO: 에러 처리
          output.isRecommendationLoading.send(false)
          print(error)
        }
      }

    case .showResultsButtonTapped:
      Task { @MainActor in
        homeRouter.navigate(
          to: HomeRoute.lottoResult, how: .push(hidesBottomBarWhenPushed: true),
          with: ["round": recommendationDetailService.round as Any])
      }

    case .backButtonTapped:
      output.back.send(())
    }
  }
}
