//
//  FortuneItemCollectionViewCell.swift
//  Home
//
//  Created by ttozzi on 8/3/25.
//

import DesignSystem
import Extension
import UIKit
import Kingfisher

struct FortuneItemCollectionViewCellModel {
  let title: String
  let imageURL: String
  let message: String
}

final class FortuneItemCollectionViewCell: UICollectionViewCell {

  private lazy var contentStackView = UIStackView().then {
    $0.spacing = 12
    $0.axis = .vertical
    $0.alignment = .center
  }
  private lazy var titleLabel = PaddingLabel().then {  // TODO: Chip
    $0.style = Typography.Body_14_SB
    $0.textColor = STColors.primary2.color
    $0.contentInsets = UIEdgeInsets(top: 3.5, left: 10, bottom: 3.5, right: 10)
    $0.layer.cornerRadius = 6
    $0.layer.borderWidth = 1
    $0.layer.borderColor = STColors.primary7.color.cgColor
  }
  private lazy var imageView = UIImageView().then {
    $0.backgroundColor = UIColor(hexString: "#F6F7F9") // TODO: 확인 필요
    $0.layer.cornerRadius = 8
    $0.clipsToBounds = true
    $0.contentMode = .scaleAspectFit
  }
  private lazy var messageLabel = UILabel().then {
    $0.style = Typography.Body_14_B.lineHeightMultiple(1.2).alignment(.center)
    $0.textColor = STColors.gray1.color
    $0.numberOfLines = .zero
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    imageView.kf.cancelDownloadTask()
    imageView.image = nil
  }

  private func setupUI() {
    contentView.backgroundColor = .clear

    contentView.addSubview(contentStackView)
    contentStackView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    contentStackView.addArrangedSubview(titleLabel)
    titleLabel.snp.makeConstraints { make in
      make.height.equalTo(28)
    }
    contentStackView.addArrangedSubview(imageView)
    imageView.snp.makeConstraints { make in
      make.width.equalToSuperview()
      make.height.equalTo(106)
    }
    contentStackView.addArrangedSubview(messageLabel)
    messageLabel.snp.makeConstraints { make in
      make.height.greaterThanOrEqualTo(21)
    }
  }

  func update(with model: FortuneItemCollectionViewCellModel) {
    titleLabel.styledText = model.title
    messageLabel.styledText = model.message
    if let imageURL = URL(string: model.imageURL) { // TODO: 서버 이미지가 2배 크기로 내려오고 있어 확인 필요
      imageView.kf.setImage(with: imageURL)
    }
  }
}

@available(iOS 17.0, *)
#Preview {
  let cellModel = FortuneItemCollectionViewCellModel(
    title: "행운의 오브제",
    imageURL: "",
    message: "보이면 낚으시길"
  )
  let cell = FortuneItemCollectionViewCell()
  cell.update(with: cellModel)
  cell.snp.makeConstraints { make in
    make.width.equalTo(138)
    make.height.equalTo(179)
  }
  return cell
}
