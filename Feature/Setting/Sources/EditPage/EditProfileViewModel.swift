//
//  EditProfileViewModel.swift
//  FeatureLayer
//
//  Created by 최재혁 on 8/16/25.
//

import Combine
import Foundation
import Onboarding
import Lib

final class EditProfileViewModel {
    enum Input {
        case viewDidLoad
        case checkNameFormat(name : String)
        case genderSelected(isSelected : GenderType)
        case checkBirthFormat(birth : String)
        case bornTimeSelected(bornTime : BornType)
        case saveButtonTap
        case timePickerTap
    }
    
    struct State {
        var name: String?
        var gender: GenderType?
        var birthDate: String?
        var bornTime: String?
        var originalUser: MockUser?
    }
    
    struct Output {
        let setupUI : PassthroughSubject<MockUser, Never> = .init()
        let showNameError: PassthroughSubject<Bool, Never> = .init()
        let showBirthError: PassthroughSubject<Bool, Never> = .init()
        let isSaveButtonEnabled: PassthroughSubject<Bool, Never> = .init()
        let navigate : PassthroughSubject<SettingRoute, Never> = .init()
    }
    
    let output : Output = Output()
    
    private var state : State = .init()
    
    private var _isNameValid: Bool = true
    private var _isBirthDateValid: Bool = true
    private var _isBornTimeValied: Bool = true
    
    func send(input : Input) {
        switch input {
        case .viewDidLoad:
            // TODO: getUser
            let mockData = MockUser(name: "콩떡빙수", gender: .male, birthDate: "1999-12-25", bornTime: "01:00~02:59")
            self.output.setupUI.send(mockData)
        case .bornTimeSelected(let bornTime):
          switch bornTime {
          case .dontKnow(let isSelected):
            self._isBornTimeValied = (self.state.bornTime != nil || !isSelected)
          case .time(let time):
            self._isBornTimeValied = true
            self.state.bornTime = time
          }
            
        case .checkBirthFormat(let birth):
          self._isBirthDateValid = checkBirthFormat(birth: birth)
          if self._isBirthDateValid { self.state.birthDate = birth }
          self.output.showBirthError.send(self._isBirthDateValid)
          self.output.isSaveButtonEnabled.send(_isNameValid && _isBirthDateValid && _isBornTimeValied)
            
        case .checkNameFormat(let name):
          self._isNameValid = checkNameFormat(name: name)
          if self._isNameValid { self.state.name = name }
          self.output.showNameError.send(self._isNameValid)
          self.output.isSaveButtonEnabled.send(_isNameValid && _isBirthDateValid && _isBornTimeValied)
            
        case .genderSelected(let isSelected):
          self.state.gender = isSelected
            
        case .timePickerTap :
            self.output.navigate.send(.timePicker)
            
        case .saveButtonTap :
            // TODO: 프로필 저장 로직 구현 필요
            break
        }
    }
    
    public init() { }
}

extension EditProfileViewModel {
    struct MockUser {
        var name: String
        var gender: GenderType
        var birthDate: String
        var bornTime: String?
    }
}

extension EditProfileViewModel {
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
