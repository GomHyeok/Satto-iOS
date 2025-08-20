//
//  HomeService.swift
//  Home
//
//  Created by ttozzi on 8/17/25.
//

import Auth
import Combine
import DIInjector
import Foundation
import NetworkCore

final class HomeService {

  @Injected private var userDataManager: UserDataManager
  @Injected private var networkProvider: NetworkProvider
  private var appVersion: String? {
    Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
  }
  private var cachedDailyFortunes: DailyFortunesDTO?
  private(set) var round: Int?
  var recommendationStateChanged: AnyPublisher<Void, Never> {
    NotificationCenter.default.publisher(for: .recommendationStateChanged)
      .map { _ in Void() }
      .eraseToAnyPublisher()
  }

  func fetch() async throws -> [any HomeCellModel] {
    let getLottoRecommendationTarget = HomeTarget.GetLottoRecommendation(
      userID: userDataManager.userID)
    async let lottoRecommendationRequest = networkProvider.request(
      target: getLottoRecommendationTarget)
    let getDailyFortunesTarget = HomeTarget.GetUserDailyFortunes(userID: userDataManager.userID)
    async let dailyFortunesRequest = networkProvider.request(target: getDailyFortunesTarget)
    let (lottoRecommendation, dailyFortunes) = try await (
      lottoRecommendationRequest, dailyFortunesRequest
    )
    self.round = lottoRecommendation.round
    self.cachedDailyFortunes = dailyFortunes

    return [
      makeHeader(round: lottoRecommendation.round, message: dailyFortunes.title),
      makeRecommendation(lottoRecommendation),
      makeTodayFortune(dailyFortunes),
    ]
  }

  func fetchLottoRecommendation() async throws -> [any HomeCellModel] {
    guard let cachedDailyFortunes else {
      return try await fetch()
    }
    let getLottoRecommendationTarget = HomeTarget.GetLottoRecommendation(
      userID: userDataManager.userID)
    let lottoRecommendation = try await networkProvider.request(
      target: getLottoRecommendationTarget)
    round = lottoRecommendation.round
    return [
      makeHeader(round: lottoRecommendation.round, message: cachedDailyFortunes.title),
      makeRecommendation(lottoRecommendation),
      makeTodayFortune(cachedDailyFortunes),
    ]
  }

  private func makeHeader(round: Int, message: String?) -> HomeHeaderCollectionViewCellModel {
    return HomeHeaderCollectionViewCellModel(
      roundText: "\(round)회",
      message: message ?? "잘 되면 꼭 기억해 주시오"
    )
  }

  private func makeRecommendation(_ lottoRecommendation: LottoRecommendationDTO)
    -> HomeRecommendationCollectionViewCellModel
  {
    let name = self.userDataManager.user?.name ?? ""  // TODO: 확인 필요
    if let recommendationContent = lottoRecommendation.content {
      let numbers = [
        recommendationContent.num1,
        recommendationContent.num2,
        recommendationContent.num3,
        recommendationContent.num4,
        recommendationContent.num5,
        recommendationContent.num6,
      ].sorted()
      return HomeRecommendationCollectionViewCellModel(
        title: "\(name)님을 위한 로또 번호 추천",
        state: lottoRecommendation.isFinished
          ? .needsResultCheck(numbers: numbers) : .recommended(numbers: numbers)
      )
    } else {
      return HomeRecommendationCollectionViewCellModel(
        title: "\(name)님을 위한 로또 번호 추천",
        state: .needsRecommendation
      )
    }
  }

  private func makeTodayFortune(_ dailyFortunes: DailyFortunesDTO)
    -> HomeTodayFortuneCollectionViewCellModel
  {
    let homeTodayFortuneCollectionViewCellModels = dailyFortunes.content.map { item in
      FortuneItemCollectionViewCellModel(
        title: item.fortuneType,
        imageURL: item.imageURL,
        message: item.description
      )
    }
    return HomeTodayFortuneCollectionViewCellModel(items: homeTodayFortuneCollectionViewCellModels)
  }
}
