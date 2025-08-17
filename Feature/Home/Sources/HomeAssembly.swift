//
//  HomeAssembly.swift
//  Home
//
//  Created by ttozzi on 8/17/25.
//

import DIInjector
import Foundation

public final class HomeAssembly: Assembly {
  public func assemble(container: Container) {
    container.register(HomeService.self) { _ in
      return HomeService()
    }
    container.register(RecommendationDetailService.self) { _ in
      return RecommendationDetailService()
    }
    container.register(HomeRouter.self) { _ in
      return HomeRouter()
    }
  }

  public init() {}
}
