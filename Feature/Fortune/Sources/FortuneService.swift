//
//  FortuneService.swift
//  FeatureLayer
//
//  Created by 최재혁 on 8/14/25.
//

import DesignSystem
import Foundation
import NetworkCore
import UIKit

struct FortuneService {
  private let networkProvider: NetworkProvider

  init(networkProvider: NetworkProvider = .shared) {
    self.networkProvider = networkProvider
  }

  func fetch() async throws -> [FortuneSection] {
    // TODO: API 연결
    try await Task.sleep(for: .seconds(2))
    return [
      .fortune(
        FortuneCollectionViewCellModel(
          dayInfo: "7월 18일",
          scoreInfo: 79,
          fortuneText: "좋은 기운이 문을 두드리고 있소"
        )
      ),
      .overall(
        OverallCollectionViewCellModel(
          title: "종합운세",
          modal: [
            OverallModalCollectionViewCellModel(
              title: "재물운",
              description: "적은 노력 뚜렷한 성과",
              image: UIImage(systemName: "star.fill") ?? UIImage()
            ),
            OverallModalCollectionViewCellModel(
              title: "취업운",
              description: "구직 성공의 기운",
              image: UIImage(systemName: "heart.fill") ?? UIImage()
            ),
            OverallModalCollectionViewCellModel(
              title: "연애운",
              description: "백억 부자 애인 각",
              image: UIImage(systemName: "circle.fill") ?? UIImage()
            ),
          ]
        )
      ),
      .thumbnail(
        ThumbnailCollectionViewCellModel(
          name: "홍길동",
          birthDate: "1990년 1월 1일",
          bornTime: "오전 10시",
          sajuMyeongSik: ThumbnailRO(
            sajuMyeongSik: SajuMyeongSik(
              siJu: SajuPair(cheonGan: "甲", jiji: "寅"),
              ilJu: SajuPair(cheonGan: "乙", jiji: "卯"),
              wolJu: SajuPair(cheonGan: "丙", jiji: "巳"),
              nyeongJu: SajuPair(cheonGan: "丁", jiji: "午")
            ),
            overallFortuneText: "근심과 즐거움이 상반하니 세월의 흐름을 잘 읽어보시게"
          ),
          day: "2025",
          strongInfo: "甲",
          weakInfo: "丙"
        )
      ),
      .moreInfo,
    ]

  }
}
