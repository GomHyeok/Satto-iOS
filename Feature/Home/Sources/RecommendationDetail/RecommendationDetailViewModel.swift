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

  enum Input {
    case viewDidLoad
    case timerFinished
    case createNewRecommendationButtonTapped
    case showResultsButtonTapped
  }

  struct Output {
    let navigationTitle = CurrentValueSubject<String?, Never>(nil)
    let sections = CurrentValueSubject<[any RecommendationDetailCellModel], Never>([])
    let isResultAvailable = CurrentValueSubject<Bool, Never>(false)
  }

  @Injected var recommendationDetailService: RecommendationDetailService
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
            let sections = try await recommendationDetailService.createRecommendation()
            output.sections.send(sections)
          } else {
            let sections = try await recommendationDetailService.fetchRecommendation()
            output.sections.send(sections)
          }
        } catch {
          // TODO: 에러 처리
          print(error)
        }
      }

    case .timerFinished:
      output.isResultAvailable.send(true)

    case .createNewRecommendationButtonTapped:
      Task {
        do {
          // TODO: 로딩 인디케이터
          let sections = try await recommendationDetailService.createRecommendation()
          output.sections.send(sections)
        } catch {
          // TODO: 에러 처리
          print(error)
        }
      }

    case .showResultsButtonTapped:
      // TODO: 결과 안내 화면
      break
    }
  }
}
