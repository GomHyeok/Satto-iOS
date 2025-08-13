//
//  OverallModalCollectionViewCell.swift
//  FeatureLayer
//
//  Created by 최재혁 on 8/12/25.
//

import Base
import DesignSystem
import UIKit

struct OverallModalCollectionViewCellModel {
  let title: String
  let description: String
  let image: UIImage  // TODO: 이미지 서버에서 내려주는지 확인 필요
}

final class OverallModalCollectionViewCell: BaseCollectionViewCell {

  private let contentStackView = UIStackView().then {
    $0.axis = .vertical
    $0.alignment = .leading
    $0.spacing = .zero
  }

  private let titleLabel = UILabel().then {
    $0.style = Typography.Body_14_SB
    $0.textColor = STColors.black.color
  }

  private let descriptionLabel = UILabel().then {
    $0.style = Typography.Caption_12_M
    $0.textColor = STColors.gray2.color
  }

  private let imageStackView = UIStackView().then {
    $0.axis = .horizontal
    $0.alignment = .trailing
  }

  private let imageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
    $0.layer.cornerRadius = 8
    $0.clipsToBounds = true
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupUI() {
    backgroundColor = STColors.white.color
    layer.cornerRadius = 10
    clipsToBounds = true
    contentView.layer.cornerRadius = 10
    contentView.clipsToBounds = true

    contentView.addSubview(contentStackView)
    contentStackView.addArrangedSubview(titleLabel)
    contentStackView.addArrangedSubview(descriptionLabel)
    contentStackView.addArrangedSubview(imageStackView)
    imageStackView.addArrangedSubview(UIView())
    imageStackView.addArrangedSubview(imageView)

    contentStackView.snp.makeConstraints { make in
      make.edges.equalToSuperview().inset(12)
    }
    contentStackView.setCustomSpacing(2, after: titleLabel)
    contentStackView.setCustomSpacing(7, after: descriptionLabel)

    imageStackView.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview()
    }

    imageView.snp.makeConstraints { make in
      make.width.height.equalTo(64)
    }
  }

  func update(with cellModel: OverallModalCollectionViewCellModel) {
    titleLabel.styledText = cellModel.title
    descriptionLabel.styledText = cellModel.description
    imageView.image = cellModel.image
  }
}

@available(iOS 17.0, *)
#Preview {
  let cell = OverallModalCollectionViewCell()
  cell.update(
    with: OverallModalCollectionViewCellModel(
      title: "전체 모달",
      description: "이곳은 전체 모달의",
      image: UIImage(systemName: "star") ?? UIImage()
    ))

  cell.snp.makeConstraints { make in
    make.width.equalTo(134)
    make.height.equalTo(136)
  }

  return cell
}
