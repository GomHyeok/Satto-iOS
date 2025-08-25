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
    let updateResultInfo = CurrentValueSubject<LottoResultInfoModel?, Never>(nil)
    let updateSattoMessage = CurrentValueSubject<SattoMessageModel?, Never>(nil)
    let updateResultNumber = CurrentValueSubject<LottoResultNumberModel?, Never>(nil)
    let isLoading = CurrentValueSubject<Bool, Never>(true)
    let back = PassthroughSubject<Void, Never>()
    let popToRoot = PassthroughSubject<Void, Never>()
    let showError = PassthroughSubject<() -> Void, Never>()
  }

  @Injected var lottoResultService: LottoResultService
  let output = Output()
  private let round: Int

  init(round: Int) {
    self.round = round
  }

  func send(input: Input) {
    switch input {
    case .viewDidLoad:
      Task {
        do {
          async let minDelay: Void = Task.sleep(for: .seconds(3))
          let response = try await lottoResultService.fetch(round: round)
          _ = try? await minDelay
          output.updateResultInfo.send(response.resultInfo)
          output.updateSattoMessage.send(response.sattoMessage)
          output.updateResultNumber.send(response.resultNumber)
          output.isLoading.send(false)
        } catch {
          output.isLoading.send(false)
          output.showError.send { [weak self] in
            self?.send(input: .viewDidLoad)
          }
          // TODO: 에러 처리
        }
      }

    case .backButtonTapped:
      output.back.send(())

    case .goToMainButtonTapped:
      output.popToRoot.send(())
    }
  }
}
