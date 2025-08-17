//
//  HomeTarget.swift
//  Home
//
//  Created by ttozzi on 8/17/25.
//

import Base
import Foundation
import NetworkCore

enum HomeTarget {

  struct GetLottoRecommendation: BaseTargetType {

    typealias Response = LottoRecommendationDTO

    var path: String { "users/\(userID)/lotto-recommendation" }
    var httpTask: HTTPTask { .requestPlain }
    var httpMethod: HTTPMethod { .get }
    var headers: [String: String]? { nil }
    let userID: String
  }

  struct CreateLottoRecommendation: BaseTargetType {

    typealias Response = LottoRecommendationDTO

    var path: String { "users/\(userID)/lotto-recommendation" }
    var httpTask: HTTPTask { .requestPlain }
    var httpMethod: HTTPMethod { .post }
    var headers: [String: String]? { nil }
    let userID: String
  }

  struct GetUserDailyFortunes: BaseTargetType {

    typealias Response = DailyFortunesDTO

    var path: String { "users/\(userID)/daily-fortunes" }
    var httpTask: HTTPTask { .requestPlain }
    var httpMethod: HTTPMethod { .get }
    var headers: [String: String]? { nil }
    let userID: String
  }
}
