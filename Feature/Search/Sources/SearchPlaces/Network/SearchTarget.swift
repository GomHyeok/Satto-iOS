//
//  SearchTarget.swift
//  FeatureLayer
//
//  Created by 최재혁 on 1/25/26.
//

import Foundation
import Base

import Moya
import NetworkCore

enum SearchTarget {
  
  struct GetSearchResults : BaseTargetType {
    typealias Response = SearchResultDTO
    
    var path : String { "lotto-stores/search"}
    var httpTask: HTTPTask {
      return .requestParameters(
        parameters: ["query": query], encoding: URLEncoding.queryString
      )
    }
    var httpMethod: HTTPMethod { .get }
    var headers: [String : String]? { nil }
    
    let query : String
  }
}
