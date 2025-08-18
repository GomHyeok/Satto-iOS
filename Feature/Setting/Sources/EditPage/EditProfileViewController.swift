//
//  EditProfileViewController.swift
//  FeatureLayer
//
//  Created by 최재혁 on 8/16/25.
//

import Base
import Combine
import DIInjector
import DesignSystem
import Foundation
import UIKit

public protocol EditProfileViewControllerProtocol {
  func showToast()
}

final class EditProfileViewController: BaseViewController {

  private var store: Set<AnyCancellable> = []
  private let viewModel: EditProfileViewModel

  var delegate: EditProfileViewControllerProtocol?

  private lazy var scrollView: UIScrollView = UIScrollView().then {
    $0.showsHorizontalScrollIndicator = false
    $0.keyboardDismissMode = .interactive
  }
  private lazy var contentView: UIView = UIView().then {
    $0.backgroundColor = STColors.white.color
  }

  private lazy var contentStackView = UIStackView().then {
    $0.axis = .vertical
    $0.spacing = 28
    $0.alignment = .leading
  }

  private lazy var backgourndView = UIView().then {
    $0.isHidden = true
    $0.backgroundColor = STColors.black.color.withAlphaComponent(0.5)
  }

  private lazy var popup = PopUp().then {
    $0.isHidden = true
    $0.update(
      titile: "수정 중인 내용이 있소", description: "저장하지 않고 화면을 벗어나면\n감쪽같이 사라질 것이오",
      actionButtonTitle: "계속 수정하기", outButtonTitle: "나가기")
  }

  private lazy var nameStack = UIStackView().then {
    $0.axis = .vertical
    $0.spacing = 8
  }

  private lazy var nameLabel: UILabel = UILabel().then {
    var style = Typography.Body_16_B
    style.color = STColors.gray1.color
    $0.style = style
    $0.styledText = "이름"
  }

  private lazy var nameTextField: UITextField = UITextField().then {
    var style = Typography.Body_14_M
    style.color = STColors.black.color
    $0.attributedPlaceholder = "김사또".set(style: style)
    $0.font = style.font?.font(size: 14)
    $0.textColor = STColors.black.color
    $0.layer.borderWidth = 1
    $0.layer.borderColor = STColors.gray7.color.cgColor
    $0.layer.cornerRadius = 6
    $0.layer.masksToBounds = true
    $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 14, height: 0))
    $0.leftViewMode = .always
  }

  private lazy var nameErrorLabel: UILabel = UILabel().then {
    var style = Typography.Caption_12_M
    style.color = STColors.red3.color
    $0.style = style
    $0.styledText = "이름은 최대 6글짜까지 입력 가능해요"
  }

  private lazy var genderStack: UIStackView = UIStackView().then {
    $0.axis = .vertical
    $0.spacing = 8
  }

  private lazy var genderLabel: UILabel = UILabel().then {
    var style = Typography.Body_16_B
    style.color = STColors.gray1.color
    $0.style = style
    $0.styledText = "성별"
  }

  private lazy var genderSelectionView: GenderSelectionView = GenderSelectionView()

  private lazy var birthStack: UIStackView = UIStackView().then {
    $0.axis = .vertical
    $0.spacing = 8
  }

  private lazy var birthLabel: UILabel = UILabel().then {
    var style = Typography.Body_16_B
    style.color = DesignSystemAsset.Colors.gray1.color
    $0.style = style
    $0.styledText = "생년월일"
  }

  private lazy var birthTextField: UITextField = UITextField().then {
    var style = Typography.Body_14_M
    style.color = STColors.black.color
    $0.attributedPlaceholder = "2000-01-01".set(style: style)
    $0.font = style.font?.font(size: 14)
    $0.textColor = STColors.black.color
    $0.layer.borderWidth = 1
    $0.layer.borderColor = STColors.gray7.color.cgColor
    $0.layer.cornerRadius = 6
    $0.layer.masksToBounds = true
    $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 14, height: 0))
    $0.leftViewMode = .always
    $0.keyboardType = .numberPad
  }

  private lazy var birthdayErrorLabel: UILabel = UILabel().then {
    var style = Typography.Caption_12_M
    style.color = STColors.red3.color
    $0.style = style
    $0.styledText = "올바른 형식으로 입력해 주세요."
  }

  private lazy var bornTimeStack: UIStackView = UIStackView().then {
    $0.axis = .vertical
    $0.spacing = 8
  }

  private lazy var bornTimeLabel: UILabel = UILabel().then {
    var style = Typography.Body_16_B
    style.color = STColors.gray1.color
    $0.style = style
    $0.styledText = "태어난 시"
  }

  private lazy var bornTimeSetButton: PickerButton = PickerButton().then {
    $0.placeholder = "23:00~00:59"
  }

  private lazy var dontKnowButton: CheckBox = CheckBox().then {
    $0.title = "모르겠어요"
    $0.isSelected = false
  }

  private lazy var saveButton: UIButton = UIButton().then {
    let style = Typography.Body_18_B
    style.color = STColors.white.color
    $0.setAttributedTitle("저장하기".set(style: style), for: .normal)
    $0.backgroundColor = STColors.primary2.color
    $0.layer.cornerRadius = 8
  }

  init(viewModel: EditProfileViewModel = EditProfileViewModel()) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupNavigationBar()
    setupUI()
    setupBind()
    setDelegate()
    viewModel.send(input: .viewDidLoad)
  }
}

extension EditProfileViewController {
  private func setupNavigationBar() {
    title = "프로필 수정"
    navigationBar.backgroundColor = STColors.white.color
    let backButtonItem = NaivgationBarButtonItem.back
    backButtonItem.tapPublisher
      .sink { [weak self] in
        self?.viewModel.send(input: .backButtonTapped)
      }
      .store(in: &store)
    setNavigationBarLeftButtonItems(items: [backButtonItem])
  }
}

// MARK: Setup
extension EditProfileViewController {

  private func setDelegate() {
    self.nameTextField.delegate = self
    self.birthTextField.delegate = self
    genderSelectionView.delegate = self
  }

  private func setupUI() {
    self.view.backgroundColor = STColors.white.color
    self.view.addSubview(scrollView)
    self.view.addSubview(saveButton)
    backgourndView.addSubview(popup)
    scrollView.addSubview(contentView)
    contentView.addSubview(contentStackView)

    contentStackView.addArrangedSubview(nameStack)
    contentStackView.addArrangedSubview(genderStack)
    contentStackView.addArrangedSubview(birthStack)
    contentStackView.addArrangedSubview(bornTimeStack)

    self.nameStack.addArrangedSubview(nameLabel)
    self.nameStack.addArrangedSubview(nameTextField)

    self.genderStack.addArrangedSubview(genderLabel)
    self.genderStack.addArrangedSubview(genderSelectionView)

    self.birthStack.addArrangedSubview(birthLabel)
    self.birthStack.addArrangedSubview(birthTextField)

    self.bornTimeStack.addArrangedSubview(bornTimeLabel)
    self.bornTimeStack.addArrangedSubview(bornTimeSetButton)
    self.bornTimeStack.addArrangedSubview(dontKnowButton)

    scrollView.snp.makeConstraints { make in
      make.edges.equalTo(view.safeAreaLayoutGuide)
    }

    contentView.snp.makeConstraints { make in
      make.edges.equalTo(scrollView.contentLayoutGuide)
      make.width.equalTo(scrollView.frameLayoutGuide)
    }

    contentStackView.snp.makeConstraints { make in
      make.top.bottom.equalToSuperview()
      make.leading.trailing.equalToSuperview().inset(24)
    }

    popup.snp.makeConstraints { make in
      make.center.equalToSuperview()
      make.width.equalTo(327)
      make.height.equalTo(206)
    }

    nameStack.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview()
    }

    nameTextField.snp.makeConstraints {
      $0.height.equalTo(43)
      $0.leading.trailing.equalToSuperview()
    }

    genderSelectionView.snp.makeConstraints {
      $0.height.equalTo(24)
      $0.leading.trailing.equalToSuperview()
    }

    birthStack.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview()
    }

    birthTextField.snp.makeConstraints {
      $0.height.equalTo(43)
      $0.leading.trailing.equalToSuperview()
    }

    bornTimeStack.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview()
    }

    bornTimeSetButton.snp.makeConstraints {
      $0.height.equalTo(43)
      $0.leading.trailing.equalToSuperview()
    }

    bornTimeStack.setCustomSpacing(12, after: bornTimeSetButton)

    saveButton.snp.makeConstraints {
      $0.height.equalTo(56)
      $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-24)
      $0.leading.equalToSuperview().offset(24)
      $0.trailing.equalToSuperview().offset(-24)
    }
  }

  private func setupBind() {
    self.viewModel.output.setupUI
      .receive(on: RunLoop.main)
      .sink { [weak self] user in
        guard let self else { return }
        self.nameTextField.text = user.name
        self.genderSelectionView.setInitialSelection(gender: user.gender.rawValue)
        self.birthTextField.text = user.birthDate
        if let bornTime = user.birthTime {
          self.bornTimeSetButton.selectedItem = "\(bornTime[0]) ~ \(bornTime[1])"
        } else {
          self.dontKnowButton.isSelected = true
          self.bornTimeSetButton.isEnabled = false
        }
      }
      .store(in: &store)

    self.viewModel.output.isSaveButtonEnabled
      .receive(on: RunLoop.main)
      .sink { [weak self] enable in
        guard let self else { return }
        self.saveButton.isEnabled = enable

        if enable {
          self.saveButton.backgroundColor = STColors.primary2.color
        } else {
          self.saveButton.backgroundColor = STColors.primary7.color
        }
      }
      .store(in: &store)

    self.viewModel.output.showNameError
      .receive(on: RunLoop.main)
      .sink { [weak self] isValid in
        guard let self else { return }
        if !isValid {
          if !nameStack.arrangedSubviews.contains(nameErrorLabel) {
            nameStack.addArrangedSubview(nameErrorLabel)
            nameStack.setCustomSpacing(6, after: nameTextField)
            nameTextField.layer.borderColor = STColors.red3.color.cgColor
          }
        } else {
          if nameStack.arrangedSubviews.contains(nameErrorLabel) {
            nameStack.removeArrangedSubview(nameErrorLabel)
            nameTextField.layer.borderColor = STColors.primary2.color.cgColor
            nameErrorLabel.removeFromSuperview()
          }
        }

        self.nameStack.layoutIfNeeded()
      }
      .store(in: &store)

    viewModel.output.showBirthError
      .receive(on: RunLoop.main)
      .sink { [weak self] isValid in
        guard let self = self else { return }
        if !isValid {
          birthTextField.layer.borderColor = STColors.red3.color.cgColor
          if !birthStack.arrangedSubviews.contains(birthdayErrorLabel) {
            birthStack.addArrangedSubview(birthdayErrorLabel)
            birthStack.setCustomSpacing(6, after: birthTextField)
          }
        } else {
          birthTextField.layer.borderColor = STColors.gray7.color.cgColor
          birthTextField.resignFirstResponder()
          if birthStack.arrangedSubviews.contains(birthdayErrorLabel) {
            birthStack.removeArrangedSubview(birthdayErrorLabel)
            birthdayErrorLabel.removeFromSuperview()
          }
        }

        self.birthStack.layoutIfNeeded()
      }
      .store(in: &store)

    viewModel.output.setTimePickerLabel
      .receive(on: RunLoop.main)
      .sink { [weak self] time in
        guard let self else { return }
        self.bornTimeSetButton.selectedItem = time
      }
      .store(in: &store)

    viewModel.output.navigate
      .receive(on: RunLoop.main)
      .sink { [weak self] route in
        guard let self else { return }
        guard let delegate else { return }
        if route == .popWithToast {
          delegate.showToast()
        }
      }
      .store(in: &store)

    viewModel.output.updatePopupHiden
      .receive(on: RunLoop.main)
      .sink { [weak self] isHidden in
        guard let self else { return }
        self.navigationController?.view.addSubview(backgourndView)
        backgourndView.snp.makeConstraints { make in
          make.edges.equalToSuperview()
        }
        self.popup.isHidden = isHidden
        self.backgourndView.isHidden = isHidden
      }
      .store(in: &store)

    popup.outButton.tapPublisher
      .sink { [weak self] _ in
        guard let self else { return }
        self.backgourndView.removeFromSuperview()
        self.navigationController?.popViewController(animated: true)
      }
      .store(in: &store)

    popup.actionButton.tapPublisher
      .sink { [weak self] _ in
        guard let self else { return }
        self.backgourndView.removeFromSuperview()
        self.popup.isHidden = true
        self.backgourndView.isHidden = true
      }
      .store(in: &store)

    saveButton.tapPublisher
      .sink { [weak self] _ in
        guard let self else { return }
        self.viewModel.send(input: .saveButtonTap)
      }
      .store(in: &store)

    bornTimeSetButton.tapPublisher
      .sink { [weak self] _ in
        guard let self else { return }
        self.viewModel.send(input: .timePickerTap)
      }
      .store(in: &store)

    dontKnowButton.gesturePublisher(gestureRecognizer: UITapGestureRecognizer())
      .sink { [weak self] _ in
        guard let self else { return }

        self.viewModel.send(
          input: .bornTimeSelected(bornTime: .dontKnow(isSelected: self.dontKnowButton.isSelected)))
        bornTimeSetButton.isEnabled.toggle()
        self.dontKnowButton.isSelected.toggle()
      }
      .store(in: &store)
  }
}

extension EditProfileViewController {
  private func setupKeyboardObservers() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(keyboardWillShow),
      name: UIResponder.keyboardWillShowNotification,
      object: nil)
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(keyboardWillHide),
      name: UIResponder.keyboardWillHideNotification,
      object: nil)
  }

  private func removeKeyboardObservers() {
    NotificationCenter.default.removeObserver(
      self, name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.removeObserver(
      self, name: UIResponder.keyboardWillHideNotification, object: nil)
  }

  @objc private func keyboardWillShow(notification: NSNotification) {
    guard let userInfo = notification.userInfo,
      let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?
        .cgRectValue
    else {
      return
    }

    let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardFrame.height, right: 0.0)
    scrollView.contentInset = contentInsets
    scrollView.scrollIndicatorInsets = contentInsets

    if let activeTextField = UIResponder.currentFirstResponder as? UITextField {
      let textFieldRect = activeTextField.convert(activeTextField.bounds, to: scrollView)
      scrollView.scrollRectToVisible(textFieldRect, animated: true)
    }
  }

  @objc private func keyboardWillHide(notification: NSNotification) {
    let contentInsets = UIEdgeInsets.zero
    scrollView.contentInset = contentInsets
    scrollView.scrollIndicatorInsets = contentInsets
  }
}

extension EditProfileViewController: GenderSelectionViewDelegate {
  func genderSelectionView(
    _ view: DesignSystem.GenderSelectionView, didSelectGender gender: String?
  ) {
    guard let gender = gender else { return }

    var genderType: GenderType

    if gender == "남성" { genderType = .male } else { genderType = .female }
    viewModel.send(input: .genderSelected(isSelected: genderType))
  }

}

extension EditProfileViewController: UITextFieldDelegate {
  public func textFieldDidBeginEditing(_ textField: UITextField) {
    textField.layer.borderColor = STColors.primary2.color.cgColor
  }

  public func textFieldDidEndEditing(_ textField: UITextField) {
    textField.layer.borderColor = STColors.gray7.color.cgColor
  }

  public func textField(
    _ textField: UITextField, shouldChangeCharactersIn range: NSRange,
    replacementString string: String
  ) -> Bool {
    guard let currentText = textField.text,
      let stringRange = Range(range, in: currentText)
    else {
      return false
    }

    let nsCurrentText = currentText as NSString
    let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

    if textField === self.nameTextField {
      viewModel.send(input: .checkNameFormat(name: updatedText))
    } else if textField === self.birthTextField {
      if updatedText.count > 10 {
        return false
      }

      if string.isEmpty && range.length == 1 {
        let deletedCharacter = nsCurrentText.substring(with: range)
        if deletedCharacter == "-" {
          if range.location > 0 {
            let newRangeLocation = range.location - 1
            let newRange = NSRange(location: newRangeLocation, length: 2)
            textField.text = nsCurrentText.replacingCharacters(in: newRange, with: "")

            return false
          }
        }
      }

      if updatedText.count == 4 {
        textField.text = updatedText + "-"
        return false
      } else if updatedText.count == 7 {
        textField.text = updatedText + "-"
        return false
      } else if updatedText.count == 10 {
        textField.text = updatedText
        viewModel.send(input: .checkBirthFormat(birth: updatedText))
        return false
      }
    }

    return true
  }

  public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    if textField === nameTextField {
      guard let name = textField.text, !name.isEmpty else {
        return false
      }
    }

    return true
  }
}
