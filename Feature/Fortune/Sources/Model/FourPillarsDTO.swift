//
//  FourPillarsDTO.swift
//  FeatureLayer
//
//  Created by 최재혁 on 8/19/25.
//

import Foundation

struct FourPillarsDTO: Codable {

  enum CodingKeys: String, CodingKey {
    case strongElement = "strong_element"
    case weakElement = "weak_element"
    case description
    case yearPillarDetail = "year_pillar_detail"
    case monthPillarDetail = "month_pillar_detail"
    case dayPillarDetail = "day_pillar_detail"
    case timePillarDetail = "time_pillar_detail"
  }

  let strongElement: String
  let weakElement: String
  let description: String
  let yearPillarDetail: PillarDetailDTO
  let monthPillarDetail: PillarDetailDTO
  let dayPillarDetail: PillarDetailDTO
  let timePillarDetail: PillarDetailDTO?

  struct PillarDetailDTO: Codable {
    let stem: String
    let branch: String
    let stemTenGod: String
    let branchTenGod: String

    enum CodingKeys: String, CodingKey {
      case stem
      case branch
      case stemTenGod = "stem_ten_god"
      case branchTenGod = "branch_ten_god"
    }
  }
}
