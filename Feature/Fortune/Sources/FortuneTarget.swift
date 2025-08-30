//
//  FortuneTarget.swift
//  FeatureLayer
//
//  Created by 최재혁 on 8/19/25.
//

import Base
import Foundation
import Moya
import NetworkCore

enum FortuneTarget {

  struct GetDailyFortuneDetail: BaseTargetType {

    typealias Response = DailyFortuneDTO

    var path: String { "users/\(userID)/daily-fortune-details" }
    var httpTask: HTTPTask {
      return .requestParameters(
        parameters: ["fortune_date": fortuneDate], encoding: URLEncoding.queryString
      )
    }
    var httpMethod: HTTPMethod { .get }
    var headers: [String: String]? { nil }
    let userID: String
    let fortuneDate: String
  }

  struct GetFourPillars: BaseTargetType {

    typealias Response = FourPillarsDTO

    var path: String { "users/\(userID)/four-pillar" }
    var httpTask: HTTPTask { .requestPlain }
    var httpMethod: HTTPMethod { .get }
    var headers: [String: String]? { nil }
    let userID: String
  }
}
