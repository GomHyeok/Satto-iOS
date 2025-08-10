//
//  DescriptionListCollectionViewCell.swift
//  Home
//
//  Created by ttozzi on 8/9/25.
//

import UIKit
import Extension
import DesignSystem

struct DescriptionListCollectionViewCellModel: RecommendationDetailCellModel {
  let descriptions: [String]
}

final class DescriptionListCollectionViewCell: UICollectionViewCell {
  
  private lazy var headerTitleLabel = UILabel().then {
    $0.style = Typography.Body_14_B
    $0.textColor = STColors.gray2.color
    $0.styledText = "그럼 이 번호, 믿어도 될까요?"
  }
  private lazy var contentStackView = UIStackView().then {
    $0.spacing = .zero
    $0.axis = .vertical
    $0.alignment = .fill
    $0.backgroundColor = STColors.white.color
    $0.layer.cornerRadius = 12
    $0.clipsToBounds = true
    $0.isLayoutMarginsRelativeArrangement = true
    $0.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
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
  }
  
  func update(with model: DescriptionListCollectionViewCellModel) {
    contentStackView.arrangedSubviews.forEach {
      $0.removeFromSuperview()
    }
    model.descriptions.forEach { description in
      let descriptionView = makeDescriptionView(text: description)
      contentStackView.addArrangedSubview(descriptionView)
    }
  }
  
  private func makeDescriptionView(text: String) -> UIStackView {
    let descriptionStackView = UIStackView().then {
      $0.spacing = 6
      $0.axis = .horizontal
      $0.alignment = .center
    }
    descriptionStackView.snp.makeConstraints { make in
      make.height.equalTo(33)
    }
    
    let checkImage = STImages.check.image.withTintColor(STColors.primary2.color)
    let imageView = UIImageView(image: checkImage).then {
      $0.contentMode = .scaleAspectFit
    }
    descriptionStackView.addArrangedSubview(imageView)
    
    let descriptionLabel = UILabel().then {
      $0.style = Typography.Body_14_SB
      $0.textColor = STColors.gray3.color
      $0.setContentHuggingPriority(UILayoutPriority(.zero), for: .horizontal)
    }
    descriptionLabel.styledText = text
    descriptionStackView.addArrangedSubview(descriptionLabel)
    
    return descriptionStackView
  }
}

@available(iOS 17.0, *)
#Preview {
  let cellModel = DescriptionListCollectionViewCellModel(
    descriptions: [
      "요즘 많이 나오는 번호가 들어 있어요",
      "끝자리가 같은 숫자가 1쌍 있어요",
      "연속 숫자 3개 이상 없이 안정적인 조합이에요",
      "홀수랑 짝수가 고르게 섞였어요"
    ]
  )
  let cell = DescriptionListCollectionViewCell()
  cell.update(with: cellModel)
  cell.snp.makeConstraints { make in
    make.height.equalTo(201)
  }
  return cell
}

