//
//  FourtuneViewModel.swift
//  FeatureLayer
//
//  Created by 최재혁 on 8/14/25.
//

import Combine
import DIInjector
import Foundation
import Auth

public final class FortuneViewModel {
  enum Input {
    case viewDidLoad
  }

  struct Output {
    let sections = CurrentValueSubject<[FortuneSection], Never>([])
    let isLoading = PassthroughSubject<Bool, Never>()
  }

  @Injected private var fortuneService: FortuneService
  @Injected private var userDataManager: UserDataManager
  
  let output: Output = Output()
  private var cancellables = Set<AnyCancellable>()

  public init() {
    userDataManager.getPublisher()
      .sink { [weak self] _ in
        guard let self else { return }
        fetchUser()
      }
      .store(in: &cancellables)
  }

  func send(input: Input) {
    switch input {
    case .viewDidLoad:
      fetchUser()
    }
  }
}

extension FortuneViewModel {
  func fetchUser() {
    output.isLoading.send(true)
    Task { [weak self] in
      guard let self else { return }
      do {
        let sections = try await self.fortuneService.fetch()
        self.output.sections.send(sections)
        output.isLoading.send(false)
      } catch {
        // TODO: 에러 처리
      }
    }
  }
}
