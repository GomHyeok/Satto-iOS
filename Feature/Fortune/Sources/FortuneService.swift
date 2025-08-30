//
//  FortuneService.swift
//  FeatureLayer
//
//  Created by 최재혁 on 8/14/25.
//

import Auth
import DIInjector
import Foundation
import NetworkCore

struct FortuneService {

  @Injected private var userDataManager: UserDataManager
  @Injected private var networkProvider: NetworkProvider

  // 확장 가능성 고려
  private var appVersion: String? {
    Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
  }

  func fetch() async throws -> [FortuneSection] {
    let name = self.userDataManager.user?.name ?? ""  // TODO: 오류 처리 필요
    let birthDate = self.userDataManager.user?.birthDate ?? ""
    var birthTime = ""

    if let value = self.userDataManager.user?.birthTime {
      birthTime = "\(value[0]) ~ \(value[1])"
    } else {
      birthTime = "정보 없소"
    }

    let date = Date()
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    let formattedDate = formatter.string(from: date)

    formatter.dateFormat = "yyyy"
    let year = formatter.string(from: date)

    let getDailyFortuneTarget = FortuneTarget.GetDailyFortuneDetail(
      userID: userDataManager.userID,
      fortuneDate: formattedDate)

    let getFourPillarsTarget = FortuneTarget.GetFourPillars(
      userID: userDataManager.userID)

    async let dailyFortuneRequest = networkProvider.request(
      target: getDailyFortuneTarget)

    async let fourPillarsRequest = networkProvider.request(
      target: getFourPillarsTarget)

    let (dailyFortune, fourPillars) = try await (
      dailyFortuneRequest, fourPillarsRequest
    )

    let modal = dailyFortune.fortuneDetails.map { detail in
      OverallModalCollectionViewCellModel(
        type: OverallModalType(rawValue: detail.type) ?? .unknown,
        title: detail.title,
        content: detail.content
      )
    }

    var siju: SajuPair? = nil

    if let day = fourPillars.timePillarDetail {
      siju = SajuPair(
        stem: day.stem,
        branch: day.branch,
        stemTenGod: day.stemTenGod,
        branchTenGod: day.branchTenGod
      )
    }

    let ilju = SajuPair(
      stem: fourPillars.dayPillarDetail.stem,
      branch: fourPillars.dayPillarDetail.branch,
      stemTenGod: fourPillars.dayPillarDetail.stemTenGod,
      branchTenGod: fourPillars.dayPillarDetail.branchTenGod
    )

    let wolju = SajuPair(
      stem: fourPillars.monthPillarDetail.stem,
      branch: fourPillars.monthPillarDetail.branch,
      stemTenGod: fourPillars.monthPillarDetail.stemTenGod,
      branchTenGod: fourPillars.monthPillarDetail.branchTenGod
    )

    let nyeongju = SajuPair(
      stem: fourPillars.yearPillarDetail.stem,
      branch: fourPillars.yearPillarDetail.branch,
      stemTenGod: fourPillars.yearPillarDetail.stemTenGod,
      branchTenGod: fourPillars.yearPillarDetail.branchTenGod
    )

    let sajuMyeongSik = SajuMyeongSik(
      siJu: siju,
      ilJu: ilju,
      wolJu: wolju,
      nyeongJu: nyeongju
    )

    let renderObject = ThumbnailRO(
      sajuMyeongSik: sajuMyeongSik,
      overallFortuneText: fourPillars.description
    )

    formatter.dateFormat = "yyyy-MM-dd"
    formatter.locale = Locale(identifier: "ko_KR")
    var outputDate = ""
    if let data = formatter.date(from: dailyFortune.fortuneDate) {
      let outputFormatter = DateFormatter()
      outputFormatter.dateFormat = "M월 d일"
      outputFormatter.locale = Locale(identifier: "ko_KR")
      outputDate = outputFormatter.string(from: data)
    }

    return [
      .fortune(
        FortuneCollectionViewCellModel(
          dayInfo: outputDate,
          scoreInfo: dailyFortune.fortuneScore,
          fortuneText: dailyFortune.fortuneComment)
      ),
      .overall(
        OverallCollectionViewCellModel(
          modal: modal
        )
      ),
      .thumbnail(
        ThumbnailCollectionViewCellModel(
          name: name,
          birthDate: birthDate,
          birthTime: birthTime,
          sajuMyeongSik: renderObject,
          day: year,
          strongInfo: fourPillars.strongElement,
          weakInfo: fourPillars.weakElement
        )
      ),
      .moreInfo,
    ]

  }
}
