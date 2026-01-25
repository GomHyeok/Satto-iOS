//
//  SearchResultDTO.swift
//  FeatureLayer
//
//  Created by 최재혁 on 1/25/26.
//

import Foundation

struct SearchResultDTO : Codable {
  
  enum CodingKeys : String, CodingKey {
    case results
  }
  
  let results : [Content]
  
  struct Content : Codable {
    let id : String
    let name : String
    let address : String
    let latitude : String
    let longitude : String
  }
}
