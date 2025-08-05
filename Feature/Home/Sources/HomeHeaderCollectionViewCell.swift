//
//  HomeHeaderCollectionViewCell.swift
//  Home
//
//  Created by ttozzi on 7/31/25.
//

import DesignSystem
import Extension
import UIKit

struct HomeHeaderCollectionViewCellModel: HomeCellModel {
  let roundText: String
  let message: String
  let imageURL: String?
}

final class HomeHeaderCollectionViewCell: UICollectionViewCell {
  
  private lazy var contentStackView = UIStackView().then {
    $0.spacing = .zero
    $0.axis = .vertical
    $0.alignment = .center
  }
  private lazy var roundTextChip = PaddingLabel().then { // TODO: Chip Component
    $0.backgroundColor = STColors.primary7.color
    $0.layer.cornerRadius = 14
    $0.clipsToBounds = true
    $0.style = Typography.Body_14_SB
    $0.textColor = STColors.primary2.color
    $0.textAlignment = .center
    $0.contentInsets = UIEdgeInsets(top: 3.5, left: 10, bottom: 3.5, right: 10)
  }
  private lazy var messageLabel = UILabel().then {
    $0.style = Typography.Heading_24_B
    $0.textColor = STColors.black.color
  }
  private lazy var imageView = UIImageView().then {
    $0.backgroundColor = .gray // TODO: 임시 영역
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupUI() {
    contentView.addSubview(contentStackView)
    contentStackView.snp.makeConstraints { make in
      make.top.leading.trailing.equalToSuperview()
      make.bottom.equalToSuperview().inset(16)
    }
    contentStackView.addArrangedSubview(roundTextChip)
    roundTextChip.snp.makeConstraints { make in
      make.height.equalTo(28)
    }
    contentStackView.setCustomSpacing(12, after: roundTextChip)
    contentStackView.addArrangedSubview(messageLabel)
    contentStackView.setCustomSpacing(28, after: messageLabel)
    contentStackView.addArrangedSubview(imageView)
    imageView.snp.makeConstraints { make in
      make.size.equalTo(120) // TODO: 확인 필요
    }
  }
  
  func update(with model: HomeHeaderCollectionViewCellModel) {
    roundTextChip.styledText = model.roundText
    messageLabel.styledText = model.message
    // TODO: imageView 로드
  }
}

@available(iOS 17.0, *)
#Preview {
  let cellModel = HomeHeaderCollectionViewCellModel(
    roundText: "1181회",
    message: "잘 되면 꼭 기억해 주세요",
    imageURL: ""
  )
  let cell = HomeHeaderCollectionViewCell()
  cell.update(with: cellModel)
  cell.snp.makeConstraints { make in
    make.height.equalTo(228)
  }
  return cell
}
