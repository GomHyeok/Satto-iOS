//
//  UserData.swift
//  Auth
//
//  Created by ttozzi on 8/15/25.
//

import Foundation

public struct UserDTO: Decodable {

  enum CodingKeys: String, CodingKey {
    case id, name, gender
    case birthDate = "birth_date"
    case birthTime = "birth_time"
  }

  public let id: String
  public let name: String
  public let birthDate: String?
  public let birthTime: [String]?
  public let gender: GenderDTO
  
  public init(id: String, name: String, birthDate: String?, birthTime: [String]?, gender: GenderDTO) {
    self.id = id
    self.name = name
    self.birthDate = birthDate
    self.birthTime = birthTime
    self.gender = gender
  }

  // TODO: 사주 정보?
}

public enum GenderDTO: String, Codable {
  case male = "M"
  case female = "F"
}
