//
//  PlaceTarget.swift
//  FeatureLayer
//
//  Created by 최재혁 on 3/15/26.
//

import Base
import Foundation
import Moya
import NetworkCore

enum PlaceTarget {
  
  struct GetWeeklyPlace: BaseTargetType {
    
    typealias Response = WeeklyPlaceDTO
    
    var path: String { "places/weekly" }
    var httpTask: HTTPTask { .requestPlain }
    var httpMethod: HTTPMethod { .get }
    var headers: [String: String]? { nil }
    let rank: String
  }
  
  struct GetRankPlace: BaseTargetType {
    
    typealias Response = RankPlaceDTO
    
    var path: String { "places/rank" }
    var httpTask: HTTPTask { .requestPlain }
    var httpMethod: HTTPMethod { .get }
    var headers: [String: String]? { nil }
    var placeID: String
  }
}
