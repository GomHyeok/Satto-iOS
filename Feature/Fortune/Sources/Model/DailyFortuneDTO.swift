//
//  DailyFortuneDTO.swift
//  FeatureLayer
//
//  Created by 최재혁 on 8/19/25.
//

import Foundation

struct DailyFortuneDTO: Decodable {
  
  enum CodingKeys : String, CodingKey {
    case id
    case userID = "user_id"
    case fortuneDate = "fortune_date"
    case fortuneScore = "fortune_score"
    case fortuneComment = "fortune_comment"
    case fortuneDetails = "fortune_details"
  }
  
  let id : Int
  let userID : String
  let fortuneDate : String
  let fortuneScore : Int
  let fortuneComment : String
  let fortuneDetails : [Content]
  
  struct Content : Decodable {
    let type : String
    let title : String
    let content : String
  }
}
