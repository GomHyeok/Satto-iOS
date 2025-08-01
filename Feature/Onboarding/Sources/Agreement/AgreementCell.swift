//
//  AgreementCell.swift
//  FeatureLayer
//
//  Created by 최재혁 on 7/30/25.
//

import DesignSystem
import SnapKit
import Then
import UIKit

protocol AgreementCellDelegate: AnyObject {
  func agreementCell(_ cell: AgreementCell, didChangeAgreement isAgreed: Bool)
  func agreementCellDidTapDetail(_ cell: AgreementCell)
}

final class AgreementCell: UICollectionViewCell {
  static let identifier = "AgreementCell"

  weak var delegate: AgreementCellDelegate?

  let checkBox: CheckBox = CheckBox().then {
    $0.isUserInteractionEnabled = true
  }

  private let detailButton: UIButton = UIButton().then {
    $0.setImage(STImages.line.image, for: .normal)
    $0.tintColor = STColors.gray5.color
  }

  override init(frame: CGRect) {
    super.init(frame: frame)

    setupView()
    bindActions()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupView() {
    contentView.addSubview(checkBox)
    contentView.addSubview(detailButton)

    checkBox.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(24)
      $0.centerY.equalToSuperview()
    }

    detailButton.snp.makeConstraints {
      $0.trailing.equalToSuperview().offset(-24)
      $0.centerY.equalToSuperview()
      $0.width.height.equalTo(16)
    }
  }

  private func bindActions() {
    checkBox.addTarget(self, action: #selector(checkBoxTapped), for: .valueChanged)
    detailButton.addTarget(self, action: #selector(detailButtonTapped), for: .touchUpInside)
  }

  @objc private func checkBoxTapped() {
    delegate?.agreementCell(self, didChangeAgreement: checkBox.isSelected)
  }

  @objc private func detailButtonTapped() {
    delegate?.agreementCellDidTapDetail(self)
  }

  func configure(with item: AgreementItem) {
    var requiredText: String
    switch item.id {
    case .all:
      requiredText = ""
    case .service, .privacy, .age:
      requiredText = item.isRequired ? "(필수) " : "(선택) "
    }
    checkBox.title = requiredText + item.title
    checkBox.isSelected = item.isAgreed
    detailButton.isHidden = !item.hasDetail  // 상세 보기 유무에 따라 버튼 숨김/표시
  }
}
