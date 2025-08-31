//
//  HistoryWebViewModel.swift
//  History
//
//  Created by ttozzi on 8/17/25.
//

import Combine
import Foundation

public final class HistoryWebViewModel {

  enum Input {
    case viewDidLoad
    case webContentProcessDidTerminate
    case recovered
  }

  struct Output {
    let loadURL = PassthroughSubject<URLRequest, Never>()
    let needsRecovery = CurrentValueSubject<Bool, Never>(false)
  }

  let output = Output()

  public init() {}

  func send(input: Input) {
    switch input {
    case .viewDidLoad:
      let url = URL(string: "https://clever-kataifi-dcedaf.netlify.app/lotto-history")!
      let request = URLRequest(url: url)
      output.loadURL.send(request)

    case .webContentProcessDidTerminate:
      output.needsRecovery.send(true)

    case .recovered:
      output.needsRecovery.send(false)
    }
  }
}
