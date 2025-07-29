//
//  OnboardingViewcontroller.swift
//  FeatureLayer
//
//  Created by 최재혁 on 7/23/25.
//

import Foundation
import UIKit
import Combine
import DesignSystem

import SnapKit
import Then

public final class OnboardingViewController: UIViewController {
    private var store: [AnyCancellable] = []
    
    private lazy var headingLabel : UILabel = UILabel().then {
        var stlye = Typography.Heading_22_B
        stlye.color = DesignSystemAsset.Colors.gray1.color
        $0.attributedText = "정보를 입력해주세요".set(
            style: stlye)
    }
    
    private lazy var subLabel : UILabel = UILabel().then {
        var stlye = Typography.Body_14_M
        stlye.color = DesignSystemAsset.Colors.gray3.color
        $0.attributedText = "회원님의 사주를 기반으로 로또 번호를 추천해 드릴게요".set(
            style: Typography.Body_14_M)
    }
    
    private lazy var onBoardingStack : UIStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 28
        $0.alignment = .leading
    }
    
    private lazy var nextButton : UIButton = UIButton().then {
        var style = Typography.Body_18_B
        style.color = DesignSystemAsset.Colors.white.color
        var styled = "다음".set(style: style)
        
        $0.setAttributedTitle(styled, for: .normal)
        $0.backgroundColor = DesignSystemAsset.Colors.primary7.color
        $0.layer.cornerRadius = 8
        $0.isEnabled = false
    }
    
    private lazy var nameStack : UIStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 8
    }
    
    private lazy var nameLabel : UILabel = UILabel().then {
        var style = Typography.Body_16_B
        style.color = DesignSystemAsset.Colors.gray1.color
        $0.attributedText = "이름".set(style: style)
    }
    
    private lazy var nameTextField : UITextField = UITextField().then {
        var style = Typography.Body_14_M
        style.color = DesignSystemAsset.Colors.gray5.color
        $0.attributedPlaceholder = "김사또".set(style: style)
        $0.font = style.font?.font(size: 14)
        $0.textColor = DesignSystemAsset.Colors.black.color
        $0.layer.borderWidth = 1
        $0.layer.borderColor = DesignSystemAsset.Colors.primary2.color.cgColor
        $0.layer.cornerRadius = 6
        $0.layer.masksToBounds = true
        $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 14, height: 0))
        $0.leftViewMode = .always
        $0.tag = 101
    }
    
    private lazy var nameErrorLabel : UILabel = UILabel().then {
        var style = Typography.Caption_12_M
        style.color = DesignSystemAsset.Colors.red3.color
        $0.attributedText = "이름은 최대 6글자까지 입력 가능해요".set(style: style)
    }
    
    private lazy var genderStack : UIStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 8
    }
    
    private lazy var genderLabel : UILabel = UILabel().then {
        var style = Typography.Body_16_B
        style.color = DesignSystemAsset.Colors.gray1.color
        $0.attributedText = "성별".set(style: style)
    }
    
    private lazy var genderSelectionView : GenderSelectionView = GenderSelectionView()
    
    private lazy var birthStack : UIStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 8
    }
    
    private lazy var birthLabel : UILabel = UILabel().then {
        var style = Typography.Body_16_B
        style.color = DesignSystemAsset.Colors.gray1.color
        $0.attributedText = "생년월일".set(style: style)
    }
    
    private lazy var birthTextField : UITextField = UITextField().then {
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
        $0.tag = 102
    }
    
    private lazy var dateTypeChipsView : DateTypeChipGroupView = DateTypeChipGroupView()

    private lazy var birthdayErrorLabel : UILabel = UILabel().then {
        var style = Typography.Caption_12_M
        style.color = STColors.red3.color
        $0.attributedText = "올바른 형식으로 입력해 주세요.".set(style: style)
    }
    
    private lazy var bornTimeStack : UIStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 8
    }
    
    private lazy var bornTimeLabel : UILabel = UILabel().then {
        var style = Typography.Body_16_B
        style.color = STColors.gray1.color
        $0.attributedText = "태어난 시".set(style: style)
    }
    
    private lazy var bornTimeSetButton : PickerButton = PickerButton().then {
        $0.placeholder = "10:00~11:00"
        $0.addTarget(self, action: #selector(bornTimeInputButtonTapped), for: .touchUpInside)
    }
    
    public init() {
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
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.navigationBar.tintColor = STColors.gray1.color
        setupBind()
        setupHierarchy()
        setupLayout()
        setupDelegate()
    }
}

// MARK: SetupView
extension OnboardingViewController {
    private func setupHierarchy() {
        self.view.addSubview(headingLabel)
        self.view.addSubview(subLabel)
        self.view.addSubview(onBoardingStack)
        self.view.addSubview(nextButton)
        
        self.onBoardingStack.addArrangedSubview(nameStack)
        
        self.nameStack.addArrangedSubview(nameLabel)
        self.nameStack.addArrangedSubview(nameTextField)
        
        self.genderStack.addArrangedSubview(genderLabel)
        self.genderStack.addArrangedSubview(genderSelectionView)
        
        self.birthStack.addArrangedSubview(birthLabel)
        self.birthStack.addArrangedSubview(birthTextField)
        self.birthStack.addArrangedSubview(dateTypeChipsView)
        
        self.bornTimeStack.addArrangedSubview(bornTimeLabel)
        self.bornTimeStack.addArrangedSubview(bornTimeSetButton)
    }
    
    private func setupDelegate() {
        nameTextField.delegate = self
        genderSelectionView.delegate = self
        dateTypeChipsView.delegate = self
        birthTextField.delegate  = self
//        bornTimeSetButton.delegate = self
    }
    
    private func setupBind() {
        
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
        
        nextButton.snp.makeConstraints{
            $0.height.equalTo(56)
            $0.bottom.equalToSuperview().offset(-60)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
        }
        
        onBoardingStack.snp.makeConstraints {
            $0.top.equalTo(self.subLabel.snp.bottom).offset(28)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
        }
        
        nameStack.snp.makeConstraints{
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
        
        dateTypeChipsView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
        }
        
        bornTimeSetButton.snp.makeConstraints {
            $0.height.equalTo(43)
            $0.leading.trailing.equalToSuperview()
        }
    }
}

// MARK: functions
extension OnboardingViewController {
    func checkFormat(text : String) -> Bool {
        let components = text.split(separator: "-").compactMap{ Int($0) }
        let calendar = Calendar.current
        
        if components.count == 3 {
            let year = components[0]
            let month = components[1]
            let day = components[2]
            
            // 1. 최소 연도는 1900년
            if year < 1900 { return false }
            
            // 2. 존재하지 않는 날짜 불가 (윤년 고려)
            var dateComponents = DateComponents()
            dateComponents.year = year
            dateComponents.month = month
            dateComponents.day = day
            
            if let date = calendar.date(from: dateComponents) {
                if date > Date() { return false }
                
                let acturalComponents = calendar.dateComponents([.year, .month, .day], from: date)
                
                if acturalComponents.year != year || acturalComponents.month != month || acturalComponents.day != day { return false }
            } else {
                return false
            }
        }
        return true
    }
    
    private func updateBirthdayErrorLabel(isValid: Bool) {
        if isValid {
            birthTextField.resignFirstResponder()
            if !onBoardingStack.contains(bornTimeStack) {
                onBoardingStack.insertArrangedSubview(bornTimeStack, at: 0)
                bornTimeStack.snp.makeConstraints {
                    $0.leading.trailing.equalToSuperview()
                }
            }
            if birthStack.arrangedSubviews.contains(birthdayErrorLabel) {
                birthStack.removeArrangedSubview(birthdayErrorLabel)
                birthdayErrorLabel.removeFromSuperview()
            }
        } else {
            birthTextField.layer.borderColor = STColors.red3.color.cgColor
            if !birthStack.arrangedSubviews.contains(birthdayErrorLabel) {
                birthStack.addArrangedSubview(birthdayErrorLabel)
                birthStack.setCustomSpacing(6, after: birthTextField)
            }
        }
    }
    
    @objc private func bornTimeInputButtonTapped() {
        // 버튼이 탭되었을 때 활성 상태로 변경
        if let pickerButton = bornTimeSetButton as? PickerButton {
            pickerButton.isActive = true
        }
        
        let bottomSheetVC = TimePickerBottomSheetViewController()
        bottomSheetVC.modalPresentationStyle = .overFullScreen
        present(bottomSheetVC, animated: true, completion: nil)
    }
}

// MARK: UITextFiledDelegate
extension OnboardingViewController : UITextFieldDelegate {
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = STColors.primary2.color.cgColor
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = STColors.gray7.color.cgColor
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = textField.text,
              let stringRange = Range(range, in: currentText) else {
            return false
        }
        
        let nsCurrentText = currentText as NSString
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        if textField == self.nameTextField {
            
            if updatedText.count > 6 {
                nameStack.addArrangedSubview(nameErrorLabel)
                nameStack.setCustomSpacing(6, after: nameTextField)
                nameTextField.layer.borderColor = STColors.red3.color.cgColor
                nextButton.isEnabled = false
            } else {
                nameStack.removeArrangedSubview(nameErrorLabel)
                nameTextField.layer.borderColor = STColors.primary2.color.cgColor
                nameErrorLabel.removeFromSuperview()
            }
        } else if textField == self.birthTextField {
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
                updateBirthdayErrorLabel(isValid: checkFormat(text: updatedText))
                return false
            }
        }

        return true
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField {
            guard let name = textField.text, !name.isEmpty else {
                return false
            }
            
            textField.resignFirstResponder()
            
            if !onBoardingStack.arrangedSubviews.contains(genderStack) {
                onBoardingStack.insertArrangedSubview(genderStack, at: 0)
            }
        }
        
        return true
    }
    
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        if textField == bornTimeTextField {
//            let bottomSheetVC = TimePickerBottomSheetViewController()
//            bottomSheetVC.modalPresentationStyle = .overFullScreen
//            present(bottomSheetVC, animated: true, completion: nil)
//            return false
//        }
        return true
    }
}

// MARK: radioButtonDelegate
extension OnboardingViewController : GenderSelectionViewDelegate {
    func genderSelectionView(_ view: GenderSelectionView, didSelectGender gender: String?) {
        guard let gender = gender else { return }
        if !onBoardingStack.arrangedSubviews.contains(birthStack) {
            onBoardingStack.insertArrangedSubview(birthStack, at: 0)
            birthTextField.becomeFirstResponder()
        }
        
        self.birthStack.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
        }
    }
}

// MARK: DateTypeChipGroupDelegate
extension OnboardingViewController : DateTypeChipGroupViewDelegate {
    func dateTypeChipGroupView(_ view: DateTypeChipGroupView, didSelectDateType dateType: String?) {
        guard let dateType = dateType else { return }
    }
}

extension OnboardingViewController : TimePickerBottomSheetDelegate {
    func timePickerBottomSheet(_ controller: TimePickerBottomSheetViewController, didSelectTimeRange timeRange: String?) {
        bornTimeSetButton.selectedItem = timeRange
    }
    
    func timePickerBottomSheetDidCancel(_ controller: TimePickerBottomSheetViewController) {
        bornTimeSetButton.layer.borderColor = STColors.gray7.color.cgColor
    }
}
