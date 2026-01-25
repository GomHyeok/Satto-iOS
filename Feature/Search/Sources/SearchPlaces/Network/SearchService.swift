//
//  SearchService.swift
//  FeatureLayer
//
//  Created by 최재혁 on 1/26/26.
//

import Foundation

import NetworkCore
import DIInjector

struct SearchService {
  
  @Injected private var networkProvider : NetworkProvider
  
  func search(query : String) async throws -> [SearchResultCellModel] {
    let getSearchResultsTarget = SearchTarget.GetSearchResults(query: query)
    
    async let searchRequst = networkProvider.request(target: getSearchResultsTarget)
    
    let modal = try await searchRequst.results.map { result in
      SearchResultCellModel(
        id : result.id,
        title : result.name,
        address : result.address,
        isMatched: query == result.name
      )
    }
    
    return modal
  }
}
