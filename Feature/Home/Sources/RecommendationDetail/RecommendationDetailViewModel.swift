//
//  RecommendationDetailViewModel.swift
//  Home
//
//  Created by ttozzi on 8/9/25.
//

import Combine
import DesignSystem
import Foundation

protocol RecommendationDetailCellModel {}

final class RecommendationDetailViewModel {

  enum Input {
    case viewDidLoad
  }

  struct Output {
    let sections = CurrentValueSubject<[any RecommendationDetailCellModel], Never>([])
  }

  let output: Output = Output()

  func send(input: Input) {
    switch input {
    case .viewDidLoad:
      // TODO: 분리 필요

      let description = "콩떡님은 화(火) 기운이 강하여\n‘지존 만수르’ 예요"  // TODO: 확인 필요
      let attributedString = NSMutableAttributedString(
        string: description,
        attributes: Typography.Body_14_B.color(STColors.gray1.color).attributes
      )
      if let range = (description as NSString).range(of: "‘지존 만수르’") as NSRange? {
        attributedString.addAttributes(
          Typography.Body_14_B.color(STColors.primary2.color).attributes, range: range)
      }

      output.sections.send([
        NumberRecommendationCollectionViewCellModel(
          roundText: "1181회",
          title: "콩떡님을 위한 로또 번호 추천",
          numbers: [9, 11, 18, 24, 33, 42],
          timeUntilDraw: "6일 2시간 59분 32초"
        ),
        AIAnalysisResultCollectionViewCellModel(
          description: attributedString,
          items: [
            .init(title: "화(火) 기운과 잘 맞는 숫자", numbers: [9, 11]),
            .init(title: "재물운 좋을 때 잘 나오는 숫자", numbers: [24, 33]),
            .init(title: "최근 자주 나온 번호", numbers: [18, 42]),
          ]
        ),
        DescriptionListCollectionViewCellModel(
          descriptions: [
            "요즘 많이 나오는 번호가 들어 있어요",
            "끝자리가 같은 숫자가 1쌍 있어요",
            "연속 숫자 3개 이상 없이 안정적인 조합이에요",
            "홀수랑 짝수가 고르게 섞였어요",
          ]
        ),
        AvoidNumberCollectionViewCellModel(
          items: [
            .init(title: "수(水) 기운과\n상충하는 숫자", numbers: [9, 11, 18]),
            .init(title: "최근 100회 동안\n거의 안 나온 숫자", numbers: [24, 33]),
          ]
        ),
      ])
    }
  }
}
