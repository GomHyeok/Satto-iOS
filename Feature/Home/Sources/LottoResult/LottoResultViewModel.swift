//
//  LottoResultViewModel.swift
//  Home
//
//  Created by ttozzi on 8/18/25.
//

import Combine
import DIInjector
import Foundation

final class LottoResultViewModel {
  
  enum Input {
    case viewDidLoad
    case backButtonTapped
    case goToMainButtonTapped
  }
  
  struct Output {
    let isLoading = CurrentValueSubject<Bool, Never>(true)
    let back = PassthroughSubject<Void, Never>()
    let popToRoot = PassthroughSubject<Void, Never>()
  }
  
  let output = Output()
  
  func send(input: Input) {
    switch input {
    case .viewDidLoad:
      Task { [weak self] in
        try await Task.sleep(for: .seconds(3))
        self?.output.isLoading.send(false)
      }
      
    case .backButtonTapped:
      output.back.send(())
      
    case .goToMainButtonTapped:
      output.popToRoot.send(())
    }
  }
}
