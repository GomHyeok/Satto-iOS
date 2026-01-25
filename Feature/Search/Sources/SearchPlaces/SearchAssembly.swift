//
//  SearchAssembly.swift
//  FeatureLayer
//
//  Created by 최재혁 on 1/26/26.
//

import DIInjector
import Foundation

public final class SearchAssembly : Assembly {
  public func assemble(container: Container) {
    container.register(SearchService.self) { _ in
      return SearchService()
    }
  }
  
  public init() {}
}
