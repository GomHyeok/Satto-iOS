//
//  AvoidNumberCollectionViewCell.swift
//  Home
//
//  Created by ttozzi on 8/9/25.
//

import DesignSystem
import Extension
import UIKit

struct AvoidNumberCollectionViewCellModel: RecommendationDetailCellModel {
  let items: [NumberCardItem]
}

final class AvoidNumberCollectionViewCell: UICollectionViewCell {

  private lazy var headerTitleLabel = UILabel().then {
    $0.style = Typography.Body_14_B
    $0.textColor = STColors.gray2.color
    $0.styledText = "제외 번호도 알려드릴게요"
  }
  private lazy var contentStackView = UIStackView().then {
    $0.spacing = 20
    $0.axis = .vertical
    $0.alignment = .fill
    $0.backgroundColor = STColors.white.color
    $0.layer.cornerRadius = 12
    $0.clipsToBounds = true
    $0.isLayoutMarginsRelativeArrangement = true
    $0.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
  }
  private lazy var descriptionLabel = UILabel().then {
    $0.style = Typography.Body_14_B.lineHeightMultiple(1.2)
    $0.textColor = STColors.gray2.color
    $0.numberOfLines = .zero
    $0.styledText = "혹시 다른 번호도 고민 중이라면,\n이 번호들은 피해주세요!"
  }
  private lazy var numberCardStackView = UIStackView().then {
    $0.spacing = 6
    $0.axis = .horizontal
    $0.distribution = .fillEqually
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupUI() {
    contentView.backgroundColor = .clear

    contentView.addSubview(headerTitleLabel)
    headerTitleLabel.snp.makeConstraints { make in
      make.top.leading.trailing.equalToSuperview()
    }

    contentView.addSubview(contentStackView)
    contentStackView.snp.makeConstraints { make in
      make.top.equalTo(headerTitleLabel.snp.bottom).offset(8)
      make.leading.trailing.bottom.equalToSuperview()
    }

    contentStackView.addArrangedSubview(descriptionLabel)
    descriptionLabel.snp.makeConstraints { make in
      make.height.equalTo(42)
    }

    contentStackView.addArrangedSubview(numberCardStackView)
  }

  func update(with model: AvoidNumberCollectionViewCellModel) {
    numberCardStackView.arrangedSubviews.forEach {
      $0.removeFromSuperview()
    }
    model.items.forEach { item in
      let numberCardView = NumberCardItemView()
      numberCardView.update(with: item)
      numberCardStackView.addArrangedSubview(numberCardView)
    }
  }
}

@available(iOS 17.0, *)
#Preview {
  let cellModel = AvoidNumberCollectionViewCellModel(
    items: [
      .init(title: "수(水) 기운과\n상충하는 숫자", numbers: [9, 11, 18]),
      .init(title: "최근 100회 동안\n거의 안 나온 숫자", numbers: [24, 33]),
    ]
  )
  let cell = AvoidNumberCollectionViewCell()
  cell.update(with: cellModel)
  cell.snp.makeConstraints { make in
    make.height.equalTo(253)
  }
  return cell
}
