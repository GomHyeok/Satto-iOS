//
//  PlaceService.swift
//  FeatureLayer
//
//  Created by 최재혁 on 3/15/26.
//

import Auth
import DIInjector
import NetworkCore
import Foundation

struct PlaceService {
  
  @Injected private var networkProvider: NetworkProvider
  
  private var appVersion: String? {
    Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
  }
  
  func fetchWeeklyPlace(rank: String) async throws -> WeeklyPlaceDTO {
    let target = PlaceTarget.GetWeeklyPlace(rank: rank)
    return try await networkProvider.request(target: target)
  }
  
  func fetchRankPlace(placeID: String) async throws -> RankPlaceDTO {
    let target = PlaceTarget.GetRankPlace(placeID: placeID)
    return try await networkProvider.request(target: target)
  }
}
