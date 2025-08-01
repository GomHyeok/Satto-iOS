//
//  DateTypeButtonView.swift
//  FeatureLayer
//
//  Created by 최재혁 on 7/26/25.
//

import DesignSystem
import SnapKit
import Then
import UIKit

// MARK: - DateTypeChipViewDelegate
protocol DateTypeChipViewDelegate: AnyObject {
  func dateTypeChipView(_ chipView: DateTypeChipView, didSelect isSelected: Bool)
}

// MARK: - DateTypeChipView (개별 칩 버튼)
class DateTypeChipView: UIView {

  weak var delegate: DateTypeChipViewDelegate?

  private let button = UIButton().then {
    $0.layer.cornerRadius = 28 / 2
    $0.layer.borderWidth = 1
    $0.layer.borderColor = DesignSystemAsset.Colors.gray7.color.cgColor
    $0.setTitleColor(STColors.gray5.color, for: .normal)
    $0.titleLabel?.font = Typography.Body_14_SB.font?.font(size: 14)

    //iOS 최소 버전을 16으로 설정했기 때문에 warning 무시하고 사용
    $0.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)  // 내부 여백
    $0.invalidateIntrinsicContentSize()
  }

  var isSelected: Bool = false {
    didSet {
      updateAppearance()
    }
  }

  var title: String? {
    didSet {
      button.setTitle(title, for: .normal)
    }
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupView()
  }

  private func setupView() {
    addSubview(button)

    button.snp.makeConstraints {
      $0.edges.equalToSuperview()
      $0.height.equalTo(28)
    }

    button.addTarget(self, action: #selector(chipTapped), for: .touchUpInside)
    updateAppearance()  // 초기 상태 설정
  }

  private func updateAppearance() {
    if isSelected {
      button.backgroundColor = DesignSystemAsset.Colors.primary2.color
      button.setTitleColor(STColors.white.color, for: .normal)
      button.layer.borderColor = STColors.primary2.color.cgColor
    } else {
      button.backgroundColor = .clear
      button.setTitleColor(STColors.gray5.color, for: .normal)
      button.layer.borderColor = STColors.gray7.color.cgColor
    }
  }

  @objc private func chipTapped() {
    delegate?.dateTypeChipView(self, didSelect: true)
  }
}
