//
//  MoreInfoCollectionViewCell.swift
//  FeatureLayer
//
//  Created by 최재혁 on 8/14/25.
//

import Base
import DesignSystem
import UIKit

final class MoreInfoCollectionViewCell: BaseCollectionViewCell {
  private lazy var contentStackView = UIStackView().then {
    $0.axis = .vertical
    $0.spacing = 12
    $0.alignment = .leading
    $0.isLayoutMarginsRelativeArrangement = true
  }

  private lazy var titleLabel = UILabel().then {
    $0.style = Typography.Body_18_B
    $0.styledText = "더 많은 행운 정보"
  }

  private lazy var moreView = UIView().then {
    $0.backgroundColor = STColors.white.color
    $0.layer.cornerRadius = 10
    $0.clipsToBounds = true
  }

  private lazy var pigImageView = UIImageView().then {
    $0.tintColor = STColors.gray5.color
    $0.image = STImages.pig.image
    $0.contentMode = .scaleAspectFit
  }

  private lazy var moreLabel = UILabel().then {
    $0.style = Typography.Body_14_R
    $0.textColor = STColors.gray5.color
    $0.styledText = "업데이트를 기다려주세요"
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setupUI() {
    contentView.addSubview(contentStackView)

    contentStackView.addArrangedSubview(titleLabel)
    contentStackView.addArrangedSubview(moreView)

    moreView.addSubview(pigImageView)
    moreView.addSubview(moreLabel)

    contentStackView.snp.makeConstraints { make in
      make.top.bottom.equalToSuperview()
      make.leading.trailing.equalToSuperview().inset(24)
    }

    titleLabel.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview()
    }

    moreView.snp.makeConstraints { make in
      make.height.equalTo(252)
      make.leading.trailing.equalToSuperview()
    }

    pigImageView.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalToSuperview().offset(59.5)
      make.width.height.equalTo(100)
    }

    moreLabel.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalTo(pigImageView.snp.bottom)
    }
  }
}

@available(iOS 17.0, *)
#Preview {
  let cell = MoreInfoCollectionViewCell()

  cell.snp.makeConstraints { make in
    make.height.equalTo(330)
  }

  return cell
}
