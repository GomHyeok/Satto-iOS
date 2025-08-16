//
//  DontKnowTimeView.swift
//  FeatureLayer
//
//  Created by 최재혁 on 7/27/25.
//

import SnapKit
import Then
import UIKit

public final class CheckBox: UIControl {

  private let checkboxImageView = UIImageView().then {
    $0.contentMode = .center
    $0.backgroundColor = STColors.white.color

    $0.layer.borderColor = STColors.gray7.color.cgColor
    $0.layer.borderWidth = 1.5
    $0.layer.cornerRadius = 6

    $0.image = STImages.check.image
    $0.isUserInteractionEnabled = false
  }

  private let titleLabel = UILabel().then {
    var style = Typography.Body_16_M
    style.color = STColors.gray1.color
    $0.style = style
    $0.styledText = "check box"
    $0.isUserInteractionEnabled = false
  }

  // MARK: - 공개 속성
  public var title: String? {
    get { titleLabel.text }
    set {
      titleLabel.styledText = newValue

      updateTitle()
    }
  }

  public override var isSelected: Bool {
    didSet {
      updateAppearance()
    }
  }

  public override var isEnabled: Bool {
    didSet {
      updateAppearance()
    }
  }

  // MARK: - 초기화
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - 설정
  private func setupView() {
    self.backgroundColor = .clear

    addSubview(checkboxImageView)
    addSubview(titleLabel)

    checkboxImageView.snp.makeConstraints {
      $0.leading.centerY.equalToSuperview()
      $0.width.height.equalTo(20)
    }

    titleLabel.snp.makeConstraints {
      $0.leading.equalTo(checkboxImageView.snp.trailing).offset(6)
      $0.centerY.equalToSuperview()
      $0.trailing.lessThanOrEqualToSuperview()
    }

    // 콘텐츠에 따라 최소 높이 설정
    self.snp.makeConstraints {
      $0.height.greaterThanOrEqualTo(24)
    }

    updateTitle()
  }

  // MARK: - UI 업데이트
  private func updateAppearance() {
    if isEnabled {
      checkboxImageView.image = STImages.check.image
      if isSelected {
        checkboxImageView.backgroundColor = STColors.primary2.color
        checkboxImageView.layer.borderColor = STColors.primary2.color.cgColor
      } else {
        checkboxImageView.backgroundColor = STColors.white.color
        checkboxImageView.layer.borderColor = STColors.gray7.color.cgColor
      }
    } else {
      checkboxImageView.backgroundColor = STColors.gray9.color
      if isSelected {
        checkboxImageView.layer.borderColor = STColors.gray9.color.cgColor
        checkboxImageView.image = STImages.checkGray.image
      } else {
        checkboxImageView.layer.borderColor = STColors.gray7.color.cgColor
        checkboxImageView.image = nil
      }
    }
  }

  private func updateTitle() {
    if isEnabled {
      titleLabel.textColor = STColors.gray1.color
    } else {
      titleLabel.textColor = STColors.gray6.color
    }

    updateAppearance()
  }

  // MARK: - 터치 처리
  public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesEnded(touches, with: event)
    if isEnabled {
      isSelected.toggle()
      sendActions(for: .valueChanged)  // 상태 변경 시 .valueChanged 이벤트를 보냅니다.
    }
  }
}
