//
//  EditProfileViewModel.swift
//  FeatureLayer
//
//  Created by 최재혁 on 8/16/25.
//

import Base
import Combine
import Foundation
import Lib
import Auth
import DIInjector

final class EditProfileViewModel {
  enum Input {
    case viewDidLoad
    case checkNameFormat(name: String)
    case genderSelected(isSelected: GenderType)
    case checkBirthFormat(birth: String)
    case bornTimeSelected(bornTime: BornType)
    case saveButtonTap
    case timePickerTap
    case backButtonTapped
  }

  struct State {
    var name: String?
    var gender: GenderType?
    var birthDate: String?
    var bornTime: [String]?
    var originalUser: UserDTO?
  }

  struct Output {
    let setupUI: PassthroughSubject<UserDTO, Never> = .init()
    let showNameError: PassthroughSubject<Bool, Never> = .init()
    let showBirthError: PassthroughSubject<Bool, Never> = .init()
    let isSaveButtonEnabled: PassthroughSubject<Bool, Never> = .init()
    let navigate: PassthroughSubject<SettingRoute, Never> = .init()
    let setTimePickerLabel : PassthroughSubject<String, Never> = .init()
    let updatePopupHiden : PassthroughSubject<Bool, Never> = .init()
  }

  let output: Output = Output()

  private var state: State = .init()
  
  @Injected private var userDataManager : UserDataManager
  @Injected private var router: SettingRouter

  private var _isNameValid: Bool = true
  private var _isBirthDateValid: Bool = true
  private var _isBornTimeValied: Bool = true
  private var _isDontKnowButtonSelected: Bool = false

  func send(input: Input) {
    switch input {
    case .viewDidLoad:
      // TODO: getUser
      Task {
        do {
          let userDTO = try await userDataManager.fetch()
          self.state.originalUser = userDTO
          self.output.setupUI.send(userDTO)
          self._isDontKnowButtonSelected = userDTO.birthTime == nil
        } catch {
          // TODO: 에러처리
        }
      }
    case .bornTimeSelected(let bornTime):
      switch bornTime {
      case .dontKnow(let isSelected):
        self._isBornTimeValied = (self.state.bornTime != nil || !isSelected)
        if !isSelected { self.state.bornTime = nil }
        self._isDontKnowButtonSelected = !isSelected
      case .time(let time):
        self._isBornTimeValied = true
        let components = time.components(separatedBy: " ~ ")
        self.state.bornTime = components
        self.output.setTimePickerLabel.send(time)
        self._isDontKnowButtonSelected = false
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
      
    case .timePickerTap:
      Task { @MainActor in
        self.router.navigate(to: SettingRoute.timePicker, how: .overFullScreen, with: ["delegate" : self ])
      }
    case .saveButtonTap:
      if let userDTO = generateUserDTO() {
        Task {
          do {
            let result = try await self.userDataManager.update(
              name: userDTO.name, birthDate: userDTO.birthDate!, birthTime: userDTO.birthTime, gender: userDTO.gender)
            self.state.originalUser = result
            self.state.name = nil
            self.state.bornTime = nil
            self.state.birthDate = nil
            self.state.gender = nil
          } catch {
            // TODO: API 호출 에러처리
            print(error)
          }
        }
      }
    case .backButtonTapped :
      if hasChanges() {
        self.output.updatePopupHiden.send(false)
      } else {
        self.output.navigate.send(.pop)
      }
    }
  }

  public init() {}
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
  
  func generateUserDTO() -> UserDTO? {
    guard let originalUser = self.state.originalUser else { return nil }

    let updatedName = self.state.name ?? originalUser.name
    var updatedGender = originalUser.gender
    let updatedBirthDate = self.state.birthDate ?? originalUser.birthDate
    var updatedBornTime: [String]? = nil
    if let bornTimeState = self.state.bornTime { updatedBornTime = bornTimeState }
    else if self.state.bornTime == nil && self._isDontKnowButtonSelected == false {
        updatedBornTime = originalUser.birthTime
    }
    if let gender = self.state.gender { updatedGender = gender == .male ? GenderDTO.male : GenderDTO.female }
    
    return UserDTO(
      id: "",
      name : updatedName,
      birthDate: updatedBirthDate,
      birthTime: updatedBornTime,
      gender: updatedGender
    )
  }
  
  private func hasChanges() -> Bool {
    guard let originalUser = self.state.originalUser else { return false }

    if let name = self.state.name, name != originalUser.name {
        return true
    }

    if let gender = self.state.gender, gender.rawValue != originalUser.gender.rawValue {
        return true
    }

    if let birthDate = self.state.birthDate, birthDate != originalUser.birthDate {
        return true
    }

    let originalBornTimeIsNil = originalUser.birthTime == nil
    if self._isDontKnowButtonSelected != originalBornTimeIsNil {
        return true
    }

    if let bornTimeState = self.state.bornTime {
        if bornTimeState != originalUser.birthTime {
            return true
        }
    }
    
    return false
  }
}

extension EditProfileViewModel : TimePickerBottomSheetDelegate {
  func timePickerBottomSheet(_ controller: TimePickerBottomSheetViewController, didSelectTimeRange timeRange: String?) {
    self.send(input: .bornTimeSelected(bornTime: .time(time: timeRange ?? "")))
  }
  
  func timePickerBottomSheetDidCancel(_ controller: TimePickerBottomSheetViewController) {
    
  }
}
