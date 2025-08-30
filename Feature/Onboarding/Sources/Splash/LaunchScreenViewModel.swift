//
//  LaunchScreenViewModel.swift
//  Onboarding
//
//  Created by ttozzi on 8/16/25.
//

import Auth
import Combine
import DIInjector
import Foundation
import Lib

public final class LaunchScreenViewModel {

  enum Input {
    case viewDidLoad
  }

  struct Output {
    let moveToSplash = PassthroughSubject<Void, Never>()
  }

  @Injected var userDataManager: UserDataManager
  @Injected var dependencyHandler: DependencyHandler
  let output = Output()

  public init() {}

  func send(input: Input) {
    switch input {
    case .viewDidLoad:
      Task { [weak self] in
        async let minDelay: Void = Task.sleep(for: .seconds(2))
        do {
          try await self?.userDataManager.fetch()
          _ = try? await minDelay
          self?.dependencyHandler.handle(key: DependencyKey.App.configureTabBarController)
        } catch {
          _ = try? await minDelay
          // TODO: 404 에러 구분 필요
          self?.output.moveToSplash.send(())
        }
      }
    }
  }
}
