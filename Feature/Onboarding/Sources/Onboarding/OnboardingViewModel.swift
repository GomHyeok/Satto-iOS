//
//  OnboardingViewModel.swift
//  FeatureLayer
//
//  Created by 최재혁 on 7/29/25.
//

import Combine
import Foundation

public enum OnboardingAction {
  case checkNameFormat(name: String)
  case genderSelected(isSelected: GenderType)
  case checkBirthFormat(birth: String)
  case bornTimeSelected(bornTime: BornType)
  case nextButtonTap
  case completeButtonTap
}

public protocol OnboardingOutputProtocol {
  var showNameError: AnyPublisher<Bool, Never> { get }
  var showBirthError: AnyPublisher<Bool, Never> { get }
  var isNextButtonEnabled: AnyPublisher<Bool, Never> { get }
}

public protocol OnboardingViewModelProtocol: OnboardingOutputProtocol {
  var inputStream: PassthroughSubject<OnboardingAction, Never> { get }
}

public class OnboardingViewModel: OnboardingViewModelProtocol {
  var stor: Set<AnyCancellable> = []

  @Published private var _isNameValid: Bool = false
  @Published private var _isBirthDateValid: Bool = false
  @Published private var _isBornTimeValied: Bool = false

  public var inputStream: PassthroughSubject<OnboardingAction, Never> = .init()

  public var isNextButtonEnabled: AnyPublisher<Bool, Never> {
    Publishers.CombineLatest3($_isNameValid, $_isBirthDateValid, $_isBornTimeValied).map {
      (nameValid, birthBalid, bornTimeValid) in
      return nameValid && birthBalid && bornTimeValid
    }
    .eraseToAnyPublisher()
  }

  public var showNameError: AnyPublisher<Bool, Never> {
    $_isNameValid
      .eraseToAnyPublisher()
  }

  public var showBirthError: AnyPublisher<Bool, Never> {
    $_isBirthDateValid
      .eraseToAnyPublisher()
  }

  private var state: State = .init()

  init() {
    inputStream
      .sink { [weak self] action in
        guard let self = self else { return }
        switch action {
        case .checkNameFormat(let name):
          self._isNameValid = checkNameFormat(name: name)
          if self._isNameValid { self.state.name = name }
        case .genderSelected(let isSelected):
          self.state.gender = isSelected
        case .checkBirthFormat(let birth):
          self._isBirthDateValid = checkBirthFormat(birth: birth)
          if self._isBirthDateValid { self.state.birthDate = birth }
        case .bornTimeSelected(let bornTime):
          switch bornTime {
          case .dontKnow(let isSelected):
            self._isBornTimeValied = (self.state.bornTime != nil || !isSelected)
          case .time(let time):
            self._isBornTimeValied = true
            self.state.bornTime = bornTime
          }
        case .nextButtonTap:
          // TODO: Modal present
          break
        case .completeButtonTap:
          // TODO: API 연결 부분
          break
        }
      }
      .store(in: &stor)
  }
}

extension OnboardingViewModel {
  struct State {
    var name: String?
    var gender: GenderType?
    var birthDate: String?
    var bornTime: BornType?
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
