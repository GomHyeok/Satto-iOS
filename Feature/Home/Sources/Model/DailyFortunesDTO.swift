//
//  DailyFortunesDTO.swift
//  Home
//
//  Created by ttozzi on 8/17/25.
//

import Foundation

struct DailyFortunesDTO: Decodable {
  
  struct FortuneItem: Decodable {
    
    enum CodingKeys: String, CodingKey {
      case fortuneType = "fortune_type"
      case imageURL = "image_url"
      case description
    }
    
    let fortuneType: String
    let imageURL: String
    let description: String
  }

  let title: String?
  let content: [FortuneItem]
}
