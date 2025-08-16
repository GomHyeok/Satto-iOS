//
//  HomeViewModel.swift
//  Home
//
//  Created by ttozzi on 7/31/25.
//

import Combine
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

  let output: Output = Output()
  
  public init() { }

  func send(input: Input) {
    switch input {
    case .viewDidLoad:
      // TODO: 분리 필요

      output.sections.send([
        HomeHeaderCollectionViewCellModel(
          roundText: "1181회",
          message: "잘 되면 꼭 기억해 주세요",
          imageURL: ""
        ),
        HomeRecommendationCollectionViewCellModel(
          dateText: "2025년 07월 17일 기준",
          title: "콩떡님을 위한 로또 번호 추천",
          state: .needsRecommendation
        ),
        HomeTodayFortuneCollectionViewCellModel(
          items: [
            FortuneItemCollectionViewCellModel(
              title: "귀인의 초성",
              imageURL: "",
              message: "연락 오면 무조건 받아라"
            ),
            FortuneItemCollectionViewCellModel(
              title: "행운의 오브제",
              imageURL: "",
              message: "보이면 낚으시길"
            ),
            FortuneItemCollectionViewCellModel(
              title: "절호의 타이밍",
              imageURL: "",
              message: "이 시간에 연락하면 안읽씹도 회신 옴"
            ),
            FortuneItemCollectionViewCellModel(
              title: "오늘의 금기",
              imageURL: "",
              message: "카페인 과다 섭취 금지"
            ),
          ]
        ),
      ])

    case .recommendationButtonTapped(let state):
      switch state {
      case .needsRecommendation:
        // TODO: 번호 추천
        break
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
