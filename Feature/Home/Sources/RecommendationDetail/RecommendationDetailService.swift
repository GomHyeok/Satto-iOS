//
//  RecommendationDetailService.swift
//  Home
//
//  Created by ttozzi on 8/17/25.
//

import Auth
import Combine
import DIInjector
import Foundation
import NetworkCore

final class RecommendationDetailService {

  @Injected private var userDataManager: UserDataManager
  @Injected private var networkProvider: NetworkProvider

  private static var recommentPublisher = PassthroughSubject<Void, Never>()

  private var username: String? { userDataManager.user?.name }
  var navigationTitle: String {
    guard let username else {
      return "로또 번호"
    }
    return "\(username)의 로또 번호"
  }
  var round: Int?

  func createRecommendation() async throws -> [any RecommendationDetailCellModel] {
    let target = HomeTarget.CreateLottoRecommendation(userID: userDataManager.userID)
    let lottoRecommendation = try await networkProvider.request(target: target)
    RecommendationDetailService.recommentPublisher.send()
    return try makeSections(from: lottoRecommendation)
  }

  func fetchRecommendation() async throws -> [any RecommendationDetailCellModel] {
    let target = HomeTarget.GetLottoRecommendation(
      userID: userDataManager.userID)
    let lottoRecommendation = try await networkProvider.request(target: target)
    round = lottoRecommendation.round
    return try makeSections(from: lottoRecommendation)
  }

  private func makeSections(from recommendation: LottoRecommendationDTO) throws
    -> [any RecommendationDetailCellModel]
  {
    let title =
      if let username = userDataManager.user?.name {
        "\(username)님을 위한 로또 번호 추천"
      } else {
        "로또 번호 추천"
      }
    guard let content = recommendation.content else {
      throw NSError()  // TODO: 예외 처리
    }
    return [
      NumberRecommendationCollectionViewCellModel(
        roundText: "\(recommendation.round)회",
        isFinished: recommendation.isFinished,
        title: title,
        numbers: [
          content.num1,
          content.num2,
          content.num3,
          content.num4,
          content.num5,
          content.num6,
        ].sorted()
      ),
      AIAnalysisResultCollectionViewCellModel(
        description: content.reason,
        items: [
          .init(
            title: "\(content.strongElement) 기운과 잘 맞는 숫자", numbers: [content.num1, content.num2]),
          .init(title: "재물운 좋을 때 잘 나오는 숫자", numbers: [content.num3, content.num4]),
          .init(title: "최근 자주 나온 번호", numbers: [content.num5, content.num6]),
        ]
      ),
      DescriptionListCollectionViewCellModel(
        descriptions: [
          "요즘 많이 나오는 번호가 들어 있소",
          "연속 숫자 3개 이상 없이 안정적인 조합이오",
          "홀짝이 고르게 섞였소이다",
          "끝자리가 같은 수가 한 쌍 있소",
        ]
      ),
      AvoidNumberCollectionViewCellModel(
        items: [
          .init(title: "\(content.weakElement) 기운과\n상충하는 숫자", numbers: content.coldNums),
          .init(title: "최근 100회 동안\n거의 안 나온 숫자", numbers: content.infrequentNums),
        ]
      ),
    ]
  }

  public static func getPublisher() -> AnyPublisher<Void, Never> {
    RecommendationDetailService.recommentPublisher
      .eraseToAnyPublisher()
  }
}
