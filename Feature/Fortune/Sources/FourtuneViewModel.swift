//
//  FourtuneViewModel.swift
//  FeatureLayer
//
//  Created by 최재혁 on 8/14/25.
//

import Combine
import DIInjector
import Foundation

final class FortuneViewModel {
  enum Input {
    case viewDidLoad
  }

  struct Output {
    let sections = CurrentValueSubject<[FortuneSection], Never>([])
  }

  @Injected private var fortuneService: FortuneService
  let output: Output = Output()

  func send(input: Input) {
    switch input {
    case .viewDidLoad:
      Task { [weak self] in
        guard let self else { return }
        do {
          let sections = try await self.fortuneService.fetch()
          self.output.sections.send(sections)
        } catch {
          // TODO: 에러 처리
        }
      }
    }
  }
}
