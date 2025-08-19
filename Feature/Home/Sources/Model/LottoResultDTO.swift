//
//  LottoResultDTO.swift
//  Home
//
//  Created by ttozzi on 8/19/25.
//

import Foundation

struct LottoResultDTO: Decodable {
  
  enum CodingKeys: String, CodingKey {
    case round
    case drawNumbers = "draw_numbers"
    case bonusNumber = "bonus_number"
    case recommendedNumbers = "recommended_numbers"
    case rank
    case prizeAmount = "prize_amount"
  }
  
  let round: Int
  let drawNumbers: [Int]
  let bonusNumber: Int
  let recommendedNumbers: [Int]
  let rank: Int?
  let prizeAmount: Double?
}
