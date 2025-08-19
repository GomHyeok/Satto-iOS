//
//  HomeService.swift
//  Home
//
//  Created by ttozzi on 8/17/25.
//

import Auth
import DIInjector
import Foundation
import NetworkCore

struct HomeService {

  @Injected private var userDataManager: UserDataManager
  @Injected private var networkProvider: NetworkProvider
  private var appVersion: String? {
    Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
  }

  func fetch() async throws -> [any HomeCellModel] {
    let name = self.userDataManager.user?.name ?? ""  // TODO: 확인 필요
    let getLottoRecommendationTarget = HomeTarget.GetLottoRecommendation(
      userID: userDataManager.userID)
    async let lottoRecommendationRequest = networkProvider.request(
      target: getLottoRecommendationTarget)
    let getDailyFortunesTarget = HomeTarget.GetUserDailyFortunes(userID: userDataManager.userID)
    async let dailyFortunesRequest = networkProvider.request(target: getDailyFortunesTarget)
    let (lottoRecommendation, dailyFortunes) = try await (
      lottoRecommendationRequest, dailyFortunesRequest
    )

    let recommendationCollectionViewCellModel: HomeRecommendationCollectionViewCellModel
    if let recommendationContent = lottoRecommendation.content {
      let numbers = [
        recommendationContent.num1,
        recommendationContent.num2,
        recommendationContent.num3,
        recommendationContent.num4,
        recommendationContent.num5,
        recommendationContent.num6,
      ].sorted()
      recommendationCollectionViewCellModel = HomeRecommendationCollectionViewCellModel(
        title: "\(name)님을 위한 로또 번호 추천",
        state: lottoRecommendation.isFinished
          ? .needsResultCheck(numbers: numbers) : .recommended(numbers: numbers)
      )
    } else {
      recommendationCollectionViewCellModel = HomeRecommendationCollectionViewCellModel(
        title: "\(name)님을 위한 로또 번호 추천",
        state: .needsRecommendation
      )
    }

    let homeTodayFortuneCollectionViewCellModels = dailyFortunes.content.map { item in
      FortuneItemCollectionViewCellModel(
        title: item.fortuneType,
        imageURL: item.imageURL,
        message: item.description
      )
    }

    return [
      HomeHeaderCollectionViewCellModel(
        roundText: "\(lottoRecommendation.round)회",
        message: dailyFortunes.title ?? "잘 되면 꼭 기억해 주시오"
      ),
      recommendationCollectionViewCellModel,
      HomeTodayFortuneCollectionViewCellModel(items: homeTodayFortuneCollectionViewCellModels),
    ]
  }
}
