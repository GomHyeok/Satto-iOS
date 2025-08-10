//
//  AIAnalysisResultCollectionViewCell.swift
//  Home
//
//  Created by ttozzi on 8/8/25.
//

import DesignSystem
import Extension
import UIKit

struct AIAnalysisResultCollectionViewCellModel: RecommendationDetailCellModel {
  let description: NSAttributedString  // TODO: 확인 필요
  let items: [NumberRecommendationItem]
}

final class AIAnalysisResultCollectionViewCell: UICollectionViewCell {

  private lazy var headerTitleLabel = UILabel().then {
    $0.style = Typography.Body_14_B
    $0.textColor = STColors.gray2.color
    $0.styledText = "AI 분석 결과, 이 번호가 뽑힌 이유는..."
  }
  private lazy var contentStackView = UIStackView().then {
    $0.spacing = 16
    $0.axis = .vertical
    $0.alignment = .fill
    $0.backgroundColor = STColors.white.color
    $0.layer.cornerRadius = 12
    $0.clipsToBounds = true
    $0.isLayoutMarginsRelativeArrangement = true
    $0.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
  }
  private lazy var descriptionLabel = UILabel().then {
    $0.style = Typography.Body_14_B
    $0.textColor = STColors.gray1.color
    $0.numberOfLines = .zero
  }
  private lazy var recommendationStackView = UIStackView().then {
    $0.spacing = 8
    $0.axis = .vertical
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

    contentStackView.addArrangedSubview(recommendationStackView)
  }

  func update(with model: AIAnalysisResultCollectionViewCellModel) {
    descriptionLabel.attributedText = model.description

    recommendationStackView.arrangedSubviews.forEach {
      $0.removeFromSuperview()
    }
    model.items.forEach { item in
      let recommendationView = NumberRecommendationItemView()
      recommendationView.update(with: item)
      recommendationStackView.addArrangedSubview(recommendationView)
    }
  }
}

@available(iOS 17.0, *)
#Preview {
  let description = "콩떡님은 화(火) 기운이 강하여\n‘지존 만수르’ 예요"
  let attributedString = NSMutableAttributedString(
    string: description,
    attributes: Typography.Body_14_B.color(STColors.gray1.color).attributes
  )
  if let range = (description as NSString).range(of: "‘지존 만수르’") as NSRange? {
    attributedString.addAttributes(
      Typography.Body_14_B.color(STColors.primary2.color).attributes, range: range)
  }
  let cellModel = AIAnalysisResultCollectionViewCellModel(
    description: attributedString,
    items: [
      .init(title: "화(火) 기운과 잘 맞는 숫자", numbers: [9, 11]),
      .init(title: "재물운 좋을 때 잘 나오는 숫자", numbers: [24, 33]),
      .init(title: "최근 자주 나온 번호", numbers: [18, 42]),
    ]
  )
  let cell = AIAnalysisResultCollectionViewCell()
  cell.update(with: cellModel)
  cell.snp.makeConstraints { make in
    make.height.equalTo(329)
  }
  return cell
}
