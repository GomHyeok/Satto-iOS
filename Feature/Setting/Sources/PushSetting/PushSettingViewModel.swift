//
//  PushSettingViewModel.swift
//  Setting
//
//  Created by ttozzi on 7/31/25.
//

import Combine
import Foundation

protocol PushSettingCellModel {}

final class PushSettingViewModel {

  enum Input {
    case viewDidLoad
    case toggleChanged(isOn: Bool)
    case backButtonTapped
  }

  struct Output {
    let sections = CurrentValueSubject<[any PushSettingCellModel], Never>([])
  }

  let output: Output = Output()

  func send(input: Input) {
    switch input {
    case .viewDidLoad:
      // TODO: 푸시 알림 설정 조회

      output.sections.send([
        PushSettingImageCollectionViewCellModel(image: nil),
        PushSettingToggleCollectionViewCellModel(
          title: "사또에게 알림 받기",
          isEnabled: true
        ),
      ])

    case .toggleChanged(let isEnabled):
      // TODO: 푸시 알림 설정 변경 or 기기 설정 이동
      break
      
    case .backButtonTapped:
      break
    }
  }
}
