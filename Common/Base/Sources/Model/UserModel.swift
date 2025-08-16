//
//  UserModel.swift
//  CommonLayer
//
//  Created by 최재혁 on 8/16/25.
//

import Foundation

public struct UserModel : Codable {
  
  enum CodingKeys : String, CodingKey {
    case id, name, gender
    case birthDate = "birth_date"
    case birthTime = "birth_time"
  }
  
  public let id : String
  let name : String
  let birthDate : String
  let birthTime : [String]?
  let gender : GenderDTO
  
  public init(id: String, name: String, birthDate: String, birthTime: [String]?, gender: GenderDTO) {
    self.id = id
    self.name = name
    self.birthDate = birthDate
    self.birthTime = birthTime
    self.gender = gender
  }
}
