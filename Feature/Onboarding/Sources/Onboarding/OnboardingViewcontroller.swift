//
//  OnboardingViewcontroller.swift
//  FeatureLayer
//
//  Created by 최재혁 on 7/23/25.
//

import Base
import Combine
import DesignSystem
import Foundation
import SnapKit
import Then
import UIKit

public final class OnboardingViewController: BaseViewController {
  private var store: Set<AnyCancellable> = []
  private let viewModel: OnboardingViewModel

  private let router: OnboardingRouter

  private lazy var scrollView: UIScrollView = UIScrollView().then {
    $0.showsVerticalScrollIndicator = false
    $0.keyboardDismissMode = .interactive
  }

  private lazy var contentView: UIView = UIView()

  private lazy var headingLabel: UILabel = UILabel().then {
    var style = Typography.Heading_22_B
    style.color = STColors.gray1.color
    $0.style = style
    $0.styledText = "정보를 입력해 주시겠소"
  }

  private lazy var subLabel: UILabel = UILabel().then {
    var style = Typography.Body_14_M
    style.color = STColors.gray3.color
    $0.style = style
    $0.styledText = "그대의 사주를 기반으로 로또 번호를 추천해 드리오"
  }

  private lazy var onBoardingStack: UIStackView = UIStackView().then {
    $0.axis = .vertical
    $0.spacing = 28
    $0.alignment = .leading
  }

  private lazy var nextButton: UIButton = UIButton().then {
    var style = Typography.Body_18_B
    style.color = DesignSystemAsset.Colors.white.color
    let styled = "다음".set(style: style)
    $0.setAttributedTitle(styled, for: .normal)
    $0.backgroundColor = STColors.primary7.color
    $0.layer.cornerRadius = 8
    $0.isEnabled = false
  }

  private lazy var nameStack: UIStackView = UIStackView().then {
    $0.axis = .vertical
    $0.spacing = 8
  }

  private lazy var nameLabel: UILabel = UILabel().then {
    var style = Typography.Body_16_B
    style.color = DesignSystemAsset.Colors.gray1.color
    $0.style = style
    $0.styledText = "이름"
  }

  private lazy var nameTextField: UITextField = UITextField().then {
    var style = Typography.Body_14_M
    style.color = STColors.gray5.color
    $0.attributedPlaceholder = "김사또".set(style: style)
    $0.font = style.font?.font(size: 14)
    $0.textColor = STColors.black.color
    $0.layer.borderWidth = 1
    $0.layer.borderColor = STColors.primary2.color.cgColor
    $0.layer.cornerRadius = 6
    $0.layer.masksToBounds = true
    $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 14, height: 0))
    $0.leftViewMode = .always
  }

  private lazy var nameErrorLabel: UILabel = UILabel().then {
    var style = Typography.Caption_12_M
    style.color = DesignSystemAsset.Colors.red3.color
    $0.style = style
    $0.styledText = "이름은 최대 6자까지 입력 가능하네"
  }

  private lazy var genderStack: UIStackView = UIStackView().then {
    $0.axis = .vertical
    $0.spacing = 8
    $0.alpha = 0.0
  }

  private lazy var genderLabel: UILabel = UILabel().then {
    var style = Typography.Body_16_B
    style.color = DesignSystemAsset.Colors.gray1.color
    $0.style = style
    $0.styledText = "성별"
  }

  private lazy var genderSelectionView: GenderSelectionView = GenderSelectionView()

  private lazy var birthStack: UIStackView = UIStackView().then {
    $0.axis = .vertical
    $0.spacing = 8
    $0.alpha = 0.0
  }

  private lazy var birthLabel: UILabel = UILabel().then {
    var style = Typography.Body_16_B
    style.color = DesignSystemAsset.Colors.gray1.color
    $0.style = style
    $0.styledText = "생년월일"
  }

  private lazy var birthTextField: UITextField = UITextField().then {
    var style = Typography.Body_14_M
    style.color = DesignSystemAsset.Colors.gray5.color
    $0.attributedPlaceholder = "2000-01-01".set(style: style)
    $0.font = style.font?.font(size: 14)
    $0.textColor = DesignSystemAsset.Colors.black.color
    $0.layer.borderWidth = 1
    $0.layer.borderColor = STColors.gray7.color.cgColor
    $0.layer.cornerRadius = 6
    $0.layer.masksToBounds = true
    $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 14, height: 0))
    $0.leftViewMode = .always
    $0.keyboardType = .numberPad
  }

  //    private lazy var dateTypeChipsView : DateTypeChipGroupView = DateTypeChipGroupView()

  private lazy var birthdayErrorLabel: UILabel = UILabel().then {
    var style = Typography.Caption_12_M
    style.color = STColors.red3.color
    $0.style = style
    $0.styledText = "올바른 형식으로 입력해 주시게"
  }

  private lazy var bornTimeStack: UIStackView = UIStackView().then {
    $0.axis = .vertical
    $0.spacing = 8
    $0.alpha = 0.0
  }

  private lazy var bornTimeLabel: UILabel = UILabel().then {
    var style = Typography.Body_16_B
    style.color = STColors.gray1.color
    $0.style = style
    $0.styledText = "태어난 시"
  }

  private lazy var bornTimeSetButton: PickerButton = PickerButton().then {
    $0.placeholder = "23:00~00:59"
    //$0.addTarget(self, action: #selector(bornTimeInputButtonTapped), for: .touchUpInside)
  }

  private lazy var dontKnowButton: CheckBox = CheckBox().then {
    $0.title = "모르겠소"
    $0.isSelected = false
    $0.addTarget(self, action: #selector(dontKonwButtonTapped), for: .touchUpInside)
  }

  init(viewModel: OnboardingViewModel = OnboardingViewModel(), router: OnboardingRouter) {
    self.viewModel = viewModel
    self.router = router
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override public func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    nameTextField.becomeFirstResponder()
  }

  override public func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
    let backButtonItem = NaivgationBarButtonItem.back
    self.setNavigationBarLeftButtonItems(items: [backButtonItem])
    setupBind()
    setupHierarchy()
    setupLayout()
    setupDelegate()
    setupKeyboardObservers()
    setupDismissKeyboardGesture()
  }

  override public func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    removeKeyboardObservers()
  }
}

// MARK: SetupView
extension OnboardingViewController {
  private func setupHierarchy() {
    self.view.addSubview(headingLabel)
    self.view.addSubview(subLabel)

    self.view.addSubview(scrollView)
    self.scrollView.addSubview(contentView)
    self.contentView.addSubview(onBoardingStack)
    //self.view.addSubview(onBoardingStack)
    self.view.addSubview(nextButton)

    self.onBoardingStack.addArrangedSubview(nameStack)

    self.nameStack.addArrangedSubview(nameLabel)
    self.nameStack.addArrangedSubview(nameTextField)

    self.genderStack.addArrangedSubview(genderLabel)
    self.genderStack.addArrangedSubview(genderSelectionView)

    self.birthStack.addArrangedSubview(birthLabel)
    self.birthStack.addArrangedSubview(birthTextField)
    //self.birthStack.addArrangedSubview(dateTypeChipsView)

    self.bornTimeStack.addArrangedSubview(bornTimeLabel)
    self.bornTimeStack.addArrangedSubview(bornTimeSetButton)
    self.bornTimeStack.addArrangedSubview(dontKnowButton)
  }

  private func setupDelegate() {
    nameTextField.delegate = self
    genderSelectionView.delegate = self
    //dateTypeChipsView.delegate = self
    birthTextField.delegate = self
  }

  private func setupBind() {

    viewModel.output.isNextButtonEnabled
      .receive(on: RunLoop.main)
      .sink { [weak self] enable in
        guard let self = self else { return }
        self.nextButton.isEnabled = enable

        if enable {
          self.nextButton.backgroundColor = STColors.primary2.color
        } else {
          self.nextButton.backgroundColor = STColors.primary7.color
        }
      }
      .store(in: &store)

    viewModel.output.showNameError
      .receive(on: RunLoop.main)
      .sink { [weak self] isValid in
        guard let self = self else { return }

        if !isValid {
          if !nameStack.arrangedSubviews.contains(nameErrorLabel) {
            nameStack.addArrangedSubview(nameErrorLabel)
            nameStack.setCustomSpacing(6, after: nameTextField)
            nameTextField.layer.borderColor = STColors.red3.color.cgColor
          }
        } else {
          if nameTextField.isFirstResponder {
            nameTextField.layer.borderColor = STColors.primary2.color.cgColor
          } else {
            nameTextField.layer.borderColor = STColors.gray7.color.cgColor
          }
          if nameStack.arrangedSubviews.contains(nameErrorLabel) {
            nameStack.removeArrangedSubview(nameErrorLabel)
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
          if !onBoardingStack.contains(bornTimeStack) && birthTextField.text?.count == 10 {
            birthTextField.resignFirstResponder()
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut) {
              
              self.onBoardingStack.insertArrangedSubview(self.bornTimeStack, at: 0)

              self.bornTimeStack.snp.makeConstraints {
                $0.leading.trailing.equalToSuperview()
              }

              self.bornTimeStack.alpha = 1.0
              self.onBoardingStack.layoutIfNeeded()
            }
          }
          if birthTextField.isFirstResponder {
            birthTextField.layer.borderColor = STColors.primary7.color.cgColor
          } else {
            birthTextField.layer.borderColor = STColors.gray7.color.cgColor
          }
          if birthStack.arrangedSubviews.contains(birthdayErrorLabel) {
            birthStack.removeArrangedSubview(birthdayErrorLabel)
            birthdayErrorLabel.removeFromSuperview()
          }
        }

        self.birthStack.layoutIfNeeded()
      }
      .store(in: &store)

    viewModel.output.navigate
      .receive(on: RunLoop.main)
      .sink { [weak self] route in
        guard let self = self else { return }
        switch route {
        case .splash:
          router.navigate(to: route, how: .clear, with: [:])
        case .onboarding:
          router.navigate(to: route, how: .push(), with: [:])
        case .agreement:
          router.navigate(to: route, how: .overFullScreen, with: ["delegate": self])
        case .timePicker:
          router.navigate(to: route, how: .overFullScreen, with: ["delegate": self])
        }
      }
      .store(in: &store)

    viewModel.output.isBornTimeButtonEnabled
      .receive(on: RunLoop.main)
      .sink { [weak self] isEnable in
        guard let self else { return }
        self.bornTimeSetButton.isEnabled = isEnable
      }
      .store(in: &store)

    nextButton.tapPublisher
      .sink { [weak self] _ in
        guard let self = self else { return }
        self.viewModel.send(input: .nextButtonTap)
      }
      .store(in: &store)

    bornTimeSetButton.tapPublisher
      .sink { [weak self] _ in
        self?.viewModel.send(input: .timePickerTap)
      }
      .store(in: &store)
  }

  private func setupLayout() {
    headingLabel.snp.makeConstraints {
      $0.top.equalTo(self.view.safeAreaLayoutGuide)
      $0.leading.equalToSuperview().offset(24)
      $0.trailing.equalToSuperview().offset(-24)
    }

    subLabel.snp.makeConstraints {
      $0.top.equalTo(headingLabel.snp.bottom).offset(6)
      $0.leading.equalToSuperview().offset(24)
      $0.trailing.equalToSuperview().offset(-24)
    }

    nextButton.snp.makeConstraints {
      $0.height.equalTo(56)
      $0.bottom.equalToSuperview().offset(-60)
      $0.leading.equalToSuperview().offset(24)
      $0.trailing.equalToSuperview().offset(-24)
    }

    scrollView.snp.makeConstraints {
      $0.top.equalTo(self.subLabel.snp.bottom).offset(28)
      $0.leading.trailing.equalToSuperview()
      $0.bottom.equalTo(self.nextButton.snp.top).offset(-28)
    }

    contentView.snp.makeConstraints {
      $0.edges.equalTo(scrollView.contentLayoutGuide)
      $0.width.equalTo(scrollView.frameLayoutGuide)
    }

    onBoardingStack.snp.makeConstraints {
      //$0.top.bottom.equalTo(self.subLabel.snp.bottom).offset(28)
      $0.top.bottom.equalToSuperview()
      $0.leading.equalToSuperview().offset(24)
      $0.trailing.equalToSuperview().offset(-24)
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

    birthStack.setCustomSpacing(6, after: birthTextField)

    birthTextField.snp.makeConstraints {
      $0.height.equalTo(43)
      $0.leading.trailing.equalToSuperview()
    }

    bornTimeSetButton.snp.makeConstraints {
      $0.height.equalTo(43)
      $0.leading.trailing.equalToSuperview()
    }

    bornTimeStack.setCustomSpacing(12, after: bornTimeSetButton)
  }

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

// MARK: functions
extension OnboardingViewController {
  @objc private func dontKonwButtonTapped() {
    viewModel.send(
      input: .bornTimeSelected(bornTime: .dontKnow(isSelected: self.dontKnowButton.isSelected)))
  }
}

// MARK: UITextFiledDelegate
extension OnboardingViewController: UITextFieldDelegate {

  public func textFieldDidBeginEditing(_ textField: UITextField) {
    if textField === nameTextField {
      viewModel.send(input: .checkNameFormat(name: textField.text ?? ""))
    } else if textField === birthTextField {
      viewModel.send(input: .checkBirthFormat(birth: textField.text ?? ""))
    }
  }

  public func textFieldDidEndEditing(_ textField: UITextField) {
    if textField === nameTextField {
      viewModel.send(input: .checkNameFormat(name: textField.text ?? ""))
    } else if textField === birthTextField {
      viewModel.send(input: .checkBirthFormat(birth: textField.text ?? ""))
    }
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
    if textField === nameTextField {
      guard let name = textField.text, !name.isEmpty else {
        return false
      }

      textField.resignFirstResponder()

      if !onBoardingStack.arrangedSubviews.contains(genderStack) && nameTextField.text!.count < 7 {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut) {
          self.onBoardingStack.insertArrangedSubview(self.genderStack, at: 0)
          self.genderStack.alpha = 1.0
          self.onBoardingStack.layoutIfNeeded()
        }
      }
    }

    return true
  }
  
  private func setupDismissKeyboardGesture() {
      let tapGesture = UITapGestureRecognizer(
        target: self,
        action: #selector(dismissKeyboard)
      )
      tapGesture.cancelsTouchesInView = false
      view.addGestureRecognizer(tapGesture)
    }

    @objc private func dismissKeyboard() {
      view.endEditing(true)
    }
}

// MARK: radioButtonDelegate
extension OnboardingViewController: GenderSelectionViewDelegate {
  func genderSelectionView(_ view: GenderSelectionView, didSelectGender gender: String?) {
    guard let gender = gender else { return }

    var genderType: GenderType

    if gender == "남성" { genderType = .male } else { genderType = .female }
    viewModel.send(input: .genderSelected(isSelected: genderType))

    if !onBoardingStack.arrangedSubviews.contains(birthStack) {
      UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut) {
        self.onBoardingStack.insertArrangedSubview(self.birthStack, at: 0)
        self.birthStack.alpha = 1.0
        self.onBoardingStack.layoutIfNeeded()
      } completion: { _ in
        self.birthTextField.becomeFirstResponder()  // 애니메이션 완료 후 포커스
      }
    }

    self.birthStack.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview()
    }
  }
}

extension OnboardingViewController: TimePickerBottomSheetDelegate {
  func timePickerBottomSheet(
    _ controller: TimePickerBottomSheetViewController, didSelectTimeRange timeRange: String?
  ) {
    bornTimeSetButton.selectedItem = timeRange
    bornTimeSetButton.isActive = false

    guard let timeRange = timeRange else { return }
    viewModel.send(input: .bornTimeSelected(bornTime: .time(time: timeRange)))
  }

  func timePickerBottomSheetDidCancel(_ controller: TimePickerBottomSheetViewController) {
    bornTimeSetButton.isActive = false
  }
}

extension OnboardingViewController: AgreementViewDelegate {
  func agreementViewDidComplete() {
    viewModel.send(input: .completeButtonTap)
  }
}

extension UIResponder {
  private static weak var _currentFirstResponder: UIResponder? = nil

  static var currentFirstResponder: UIResponder? {
    _currentFirstResponder = nil
    UIApplication.shared.sendAction(
      #selector(findFirstResponder(sender:)), to: nil, from: nil, for: nil)
    return _currentFirstResponder
  }

  @objc private func findFirstResponder(sender: Any) {
    UIResponder._currentFirstResponder = self
  }
}

#if targetEnvironment(simulator)

  import DIInjector
  import Auth
  //  import Setting
  import NetworkCore

  @available(iOS 17.0, *)
  #Preview {
    DependencyInjector.shared.assemble([
      AuthAssembly(),
      //      SettingAssembly(),
      NetworkCoreAssembly(),
    ])
    return OnboardingViewController(router: OnboardingRouter())
  }
#endif
