//
//  SendFeedbackCollectionViewCell.swift
//  Setting
//
//  Created by ttozzi on 7/26/25.
//

import DesignSystem
import SnapKit
import Then
import UIKit

struct SendFeedbackCollectionViewCellModel {
  let description: String?
  let feedbackButtonTitle: String?
}

final class SendFeedbackCollectionViewCell: UICollectionViewCell {

  private lazy var contentStackView = UIStackView().then {
    $0.axis = .horizontal
    $0.alignment = .center
    $0.spacing = 14
  }
  private lazy var feedbackAreaStackView = UIStackView().then {
    $0.axis = .vertical
    $0.alignment = .leading
    $0.spacing = 12
  }
  private lazy var descriptionLabel = UILabel().then {
    $0.style = Typography.Body_14_SB
    $0.numberOfLines = 2
  }
  private lazy var sendFeedbackStackView = UIStackView().then {
    $0.axis = .horizontal
    $0.spacing = 4
    $0.alignment = .center
    $0.layoutMargins = UIEdgeInsets(top: .zero, left: 12, bottom: .zero, right: 12)
    $0.isLayoutMarginsRelativeArrangement = true
    $0.backgroundColor = STColors.primary8.color
    $0.clipsToBounds = true
    $0.layer.cornerRadius = 6
  }
  private lazy var sendFeedbackLabel = UILabel().then {
    $0.backgroundColor = .clear
    $0.style = Typography.Caption_12_B
    $0.textColor = STColors.primary2.color
    $0.styledText = "의견 보내기"
  }
  private lazy var arrowRightView = UIImageView().then {
    $0.image = STImages.chevronRightS.image.withRenderingMode(.alwaysTemplate)
    $0.contentMode = .scaleAspectFit
    $0.tintColor = STColors.primary2.color
  }
  private lazy var imageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
    $0.image = STImages.imageSend.image
    $0.setContentHuggingPriority(.required, for: .horizontal)
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
    contentStackView.backgroundColor = .clear

    contentView.addSubview(contentStackView)
    contentStackView.snp.makeConstraints { make in
      make.edges.equalToSuperview().inset(20)
    }

    contentStackView.addArrangedSubview(feedbackAreaStackView)
    feedbackAreaStackView.addArrangedSubview(descriptionLabel)
    feedbackAreaStackView.addArrangedSubview(sendFeedbackStackView)
    sendFeedbackStackView.snp.makeConstraints { make in
      make.height.equalTo(32)
    }
    sendFeedbackStackView.addArrangedSubview(sendFeedbackLabel)
    sendFeedbackStackView.addArrangedSubview(arrowRightView)
    arrowRightView.snp.makeConstraints { make in
      make.size.equalTo(20)
    }

    contentStackView.addArrangedSubview(imageView)
    imageView.snp.makeConstraints { make in
      make.size.equalTo(86)
    }
  }

  func update(with cellModel: SendFeedbackCollectionViewCellModel) {
    descriptionLabel.styledText = cellModel.description
  }
}

@available(iOS 17.0, *)
#Preview {
  let cellModel = SendFeedbackCollectionViewCellModel(
    description: "더 나은 서비스를 위해,\n여러분의 목소리를 들려주세요",
    feedbackButtonTitle: "의견 보내기"
  )
  let cell = SendFeedbackCollectionViewCell()
  cell.snp.makeConstraints { make in
    make.height.equalTo(130)
  }
  cell.update(with: cellModel)
  return cell
}
