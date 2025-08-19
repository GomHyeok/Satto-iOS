//
//  LottoRecommendationDTO.swift
//  Home
//
//  Created by ttozzi on 8/17/25.
//

import Foundation

struct LottoRecommendationDTO: Decodable {

  enum CodingKeys: String, CodingKey {
    case userId = "user_id"
    case round
    case content
    case isFinished = "is_finished"
  }

  let userId: String
  let round: Int
  let content: Content?
  let isFinished: Bool

  struct Content: Codable {

    enum CodingKeys: String, CodingKey {
      case reason
      case num1, num2, num3, num4, num5, num6
      case coldNums = "cold_nums"
      case infrequentNums = "infrequent_nums"
      case strongElement = "strong_element"
      case weakElement = "weak_element"
    }

    let reason: String
    let num1: Int
    let num2: Int
    let num3: Int
    let num4: Int
    let num5: Int
    let num6: Int
    let coldNums: [Int]
    let infrequentNums: [Int]
    let strongElement: String
    let weakElement: String
  }
}
