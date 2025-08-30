//
//  OnboardingViewModel.swift
//  FeatureLayer
//
//  Created by 최재혁 on 7/29/25.
//

import Auth
import Base
import Combine
import DIInjector
import Foundation
import Lib

public class OnboardingViewModel {

  enum Input {
    case backButtonTap
    case checkNameFormat(name: String)
    case genderSelected(isSelected: GenderType)
    case checkBirthFormat(birth: String)
    case bornTimeSelected(bornTime: BornType)
    case nextButtonTap
    case completeButtonTap
    case timePickerTap
  }

  struct Output {
    let showNameError: PassthroughSubject<Bool, Never> = .init()
    let showBirthError: PassthroughSubject<Bool, Never> = .init()
    let isNextButtonEnabled: PassthroughSubject<Bool, Never> = .init()
    let isBornTimeButtonEnabled: PassthroughSubject<Bool, Never> = .init()
    let navigate: PassthroughSubject<OnboardingRoute, Never> = .init()
    let back: PassthroughSubject<Void, Never> = .init()
    let showError: PassthroughSubject<() -> Void, Never> = .init()
  }

  let output: Output = Output()

  @Injected private var userDataManager: UserDataManager
  @Injected private var dependencyHandler: DependencyHandler

  private var _isNameValid: Bool = false
  private var _isBirthDateValid: Bool = false
  private var _isBornTimeValied: Bool = false
  private var _isDontKnowSelected: Bool = false

  private var state: State = .init()

  func send(input: Input) {
    switch input {
    case .backButtonTap:
      self.output.back.send(())
    case .checkNameFormat(let name):
      self._isNameValid = checkNameFormat(name: name)
      if self._isNameValid { self.state.name = name }
      self.output.showNameError.send(self._isNameValid)
      self.output.isNextButtonEnabled.send(_isNameValid && _isBirthDateValid && _isBornTimeValied)
    case .genderSelected(let isSelected):
      self.state.gender = isSelected
    case .checkBirthFormat(let birth):
      self._isBirthDateValid = checkBirthFormat(birth: birth)
      if self._isBirthDateValid { self.state.birthDate = birth }
      self.output.showBirthError.send(self._isBirthDateValid)
      self.output.isNextButtonEnabled.send(_isNameValid && _isBirthDateValid && _isBornTimeValied)
    case .bornTimeSelected(let bornTime):
      switch bornTime {
      case .dontKnow(let isSelected):
        self._isBornTimeValied = (self.state.bornTime != nil || !isSelected)
        self._isDontKnowSelected = !isSelected
        self.output.isBornTimeButtonEnabled.send(isSelected)
      case .time(let time):
        self._isBornTimeValied = true
        let components = time.components(separatedBy: " ~ ")
        self.state.bornTime = components
      }
      self.output.isNextButtonEnabled.send(_isNameValid && _isBirthDateValid && _isBornTimeValied)
    case .nextButtonTap:
      self.output.navigate.send(.agreement)
    case .completeButtonTap:
      if let name = state.name, let birthDate = state.birthDate, let gender = state.gender {
        let genderDTO = gender == .male ? GenderDTO.male : GenderDTO.female
        var birthTime: [String]? = nil
        if !self._isDontKnowSelected {
          birthTime = self.state.bornTime
        }
        Task {
          do {
            let _ = try await self.userDataManager.create(
              name: name, birthDate: birthDate, birthTime: birthTime, gender: genderDTO)
            await MainActor.run {
              self.dependencyHandler.handle(key: DependencyKey.App.configureTabBarController)
            }
          } catch {
            // TODO: API 호출 에러처리
            self.output.showError.send {
              self.send(input: .completeButtonTap)
            }
          }
        }
      } else {
        // TODO: 입력값에 대한 에러 처리
      }
    case .timePickerTap:
      self.output.navigate.send(.timePicker)
    }
  }

  public init() {}
}

extension OnboardingViewModel {
  struct State {
    var name: String?
    var gender: GenderType?
    var birthDate: String?
    var bornTime: [String]?
  }
}

extension OnboardingViewModel {
  func checkNameFormat(name: String) -> Bool {
    if name.count > 6 { return false } else { return true }
  }

  func checkBirthFormat(birth: String) -> Bool {
    let components = birth.split(separator: "-").compactMap { Int($0) }
    let calendar = Calendar.current

    if components.count == 3 {
      let year = components[0]
      let month = components[1]
      let day = components[2]

      // 최소 년도 1900
      if year < 1900 { return false }

      // 존재 하지 않는 날짜 filter
      var dateComponents = DateComponents()
      dateComponents.year = year
      dateComponents.month = month
      dateComponents.day = day

      if let date = calendar.date(from: dateComponents) {
        if date > Date() { return false }

        let actualComponents = calendar.dateComponents([.year, .month, .day], from: date)

        if actualComponents.year != year || actualComponents.month != month
          || actualComponents.day != day
        {
          return false
        }
      }
    }

    return true
  }
}
