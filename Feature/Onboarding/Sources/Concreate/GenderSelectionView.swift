//
//   GenderSelectionView.swift
//   FeatureLayer
//
//   Created by 최재혁 on 7/26/25.
//

import SnapKit
import Then
import UIKit

// MARK: - GenderSelectionViewDelegate (성별 선택 그룹에서 선택된 성별을 알리는 프로토콜)
protocol GenderSelectionViewDelegate: AnyObject {
  func genderSelectionView(_ view: GenderSelectionView, didSelectGender gender: String?)
}

// MARK: - GenderSelectionView (라디오 버튼 그룹)
class GenderSelectionView: UIView {

  // 델리게이트를 통해 상위 뷰에 선택된 성별을 알림
  weak var delegate: GenderSelectionViewDelegate?

  // 라디오 버튼들을 정렬하기 위한 스택 뷰
  private let stackView = UIStackView().then {
    $0.axis = .horizontal
    $0.spacing = 20
  }

  private var radioButtons: [RadioButtonView] = []

  // 현재 선택된 성별 텍스트
  private var selectedGender: String? {
    didSet {
      delegate?.genderSelectionView(self, didSelectGender: selectedGender)
    }
  }

  // 코드 기반 초기화
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupView()
  }

  // 뷰의 초기 설정
  private func setupView() {
    addSubview(stackView)

    stackView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }

    addGenderOptions()
  }

  // 성별 옵션 (남성, 여성) 라디오 버튼 추가
  private func addGenderOptions() {
    let maleRadioButton = RadioButtonView().then {
      $0.title = "남성"
      $0.delegate = self
    }

    radioButtons.append(maleRadioButton)
    stackView.addArrangedSubview(maleRadioButton)

    let femaleRadioButton = RadioButtonView().then {
      $0.title = "여성"
      $0.delegate = self
    }
    radioButtons.append(femaleRadioButton)
    stackView.addArrangedSubview(femaleRadioButton)
  }

  // 특정 인덱스의 라디오 버튼을 선택 상태로 만듦
  private func selectRadioButton(at index: Int) {
    guard index < radioButtons.count else { return }

    for (i, button) in radioButtons.enumerated() {
      button.isSelected = (i == index)
    }
    selectedGender = radioButtons[index].title
  }
}

extension GenderSelectionView: RadioButtonViewDelegate {
  // MARK: - RadioButtonViewDelegate (RadioButtonView로부터 탭 이벤트 수신)
  func radioButtonView(_ radioButtonView: RadioButtonView, didSelect isSelected: Bool) {
    // 어떤 라디오 버튼이 탭되었는지 확인하고 해당 버튼을 선택 상태로 만듦
    for (i, button) in radioButtons.enumerated() {
      if button === radioButtonView {  // 탭된 버튼이 현재 버튼과 동일한 경우
        selectRadioButton(at: i)  // 해당 버튼을 선택 상태로 설정
        break
      }
    }
  }
}
