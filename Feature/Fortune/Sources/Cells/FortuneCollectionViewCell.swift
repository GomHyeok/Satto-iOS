//
//  FortuneCollectionViewCell.swift
//  FeatureLayer
//
//  Created by 최재혁 on 8/8/25.
//

import Base
import DesignSystem
import Extension
import SnapKit
import Then
import UIKit

struct FortuneCollectionViewCellModel {
  let dayInfo: String
  let scoreInfo: Int
  let fortuneText: String?
}

final class FortuneCollectionViewCell: BaseCollectionViewCell {

  private lazy var contentStackView = UIStackView().then {
    $0.axis = .vertical
    $0.spacing = 6
    $0.alignment = .center
  }

  private lazy var dayInfoLabel = PaddingLabel().then {
    $0.style = Typography.Body_14_SB
    $0.textColor = STColors.primary2.color
    $0.backgroundColor = STColors.primary7.color
    $0.layer.cornerRadius = 14
    $0.clipsToBounds = true
    $0.textAlignment = .center
    $0.contentInsets = UIEdgeInsets(top: 3.5, left: 10, bottom: 3.5, right: 10)
  }

  private lazy var scoreInfoLabel = UILabel().then {
    $0.style = Typography.Display_28_B
    $0.textColor = STColors.gray1.color
    $0.textAlignment = .center
  }

  private lazy var scoreArcView = ScoreArcView().then {
    $0.contentInsets = UIEdgeInsets(top: 11, left: 20, bottom: 11, right: 20)
  }

  private lazy var fortuneInfoLabel = UILabel().then {
    $0.style = Typography.Body_16_M
    $0.textColor = STColors.gray1.color
    $0.textAlignment = .center
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupUI() {
    backgroundColor = .clear
    contentView.addSubview(dayInfoLabel)
    contentView.addSubview(contentStackView)
    contentStackView.addArrangedSubview(scoreInfoLabel)
    contentStackView.addArrangedSubview(scoreArcView)
    contentStackView.addArrangedSubview(fortuneInfoLabel)

    dayInfoLabel.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.centerX.equalToSuperview()
    }

    contentStackView.snp.makeConstraints { make in
      make.top.equalTo(dayInfoLabel.snp.bottom).offset(12)
      make.leading.trailing.equalToSuperview()
      make.centerY.equalToSuperview()
    }

    scoreArcView.snp.makeConstraints { make in
      make.height.equalTo(78)
      make.width.equalTo(156)
    }
  }

  func update(with cellModel: FortuneCollectionViewCellModel) {
    dayInfoLabel.styledText = "\(cellModel.dayInfo) 행운 지수"
    scoreInfoLabel.styledText = "\(cellModel.scoreInfo)점"
    scoreArcView.score = CGFloat(cellModel.scoreInfo)
    fortuneInfoLabel.styledText = cellModel.fortuneText

    scoreArcView.update(
      background: STColors.primary6.color, fill: STColors.primary4.color, lineWidth: 20,
      lineCap: .butt)

    scoreArcView.animateInitialScore()
  }

}

@available(iOS 17.0, *)
#Preview {
  let stackView = UIStackView().then {
    $0.axis = .vertical
    $0.spacing = .zero
  }
  let cell = FortuneCollectionViewCell().then {
    $0.update(
      with: FortuneCollectionViewCellModel(
        dayInfo: "8월 8일", scoreInfo: 85, fortuneText: "좋은 기운이 문을 두들기고 있소"))
  }

  cell.snp.makeConstraints { make in
    make.height.equalTo(218)
  }
  stackView.addArrangedSubview(cell)

  return stackView
}
