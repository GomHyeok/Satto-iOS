//
//  SattoMessageView.swift
//  Home
//
//  Created by ttozzi on 8/18/25.
//

import DesignSystem
import UIKit

struct SattoMessageModel {
  let title: String
  let message: String
}

final class SattoMessageView: UIView {

  private lazy var contentStackView = UIStackView().then {
    $0.axis = .vertical
    $0.spacing = 16
    $0.alignment = .fill
  }
  private lazy var titleLabel = UILabel().then {
    $0.style = Typography.Body_16_B.color(STColors.gray2.color)
  }
  private lazy var messageContentStackView = UIStackView().then {
    $0.axis = .horizontal
    $0.spacing = 7
  }
  private lazy var pigImageView = UIImageView().then {
    $0.image = STImages.cloverPig.image
    $0.contentMode = .scaleAspectFit
    $0.setContentHuggingPriority(.required, for: .horizontal)
  }
  private lazy var messageBubbleImageView = UIImageView().then {
    $0.image = STImages.messageBubble.image
    $0.contentMode = .scaleToFill
  }
  private lazy var messageLabel = UILabel().then {
    $0.style = Typography.Body_14_B.color(STColors.gray2.color).lineHeightMultiple(1.2)
    $0.numberOfLines = 2
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func update(with model: SattoMessageModel) {
    titleLabel.styledText = model.title
    messageLabel.styledText = model.message
  }

  private func setupUI() {
    backgroundColor = STColors.primary8.color
    layer.cornerRadius = 16
    clipsToBounds = true

    addSubview(contentStackView)
    contentStackView.snp.makeConstraints { make in
      make.edges.equalToSuperview().inset(20)
    }

    contentStackView.addArrangedSubview(titleLabel)
    titleLabel.snp.makeConstraints { make in
      make.height.greaterThanOrEqualTo(24)
    }

    contentStackView.addArrangedSubview(messageContentStackView)

    messageContentStackView.addArrangedSubview(pigImageView)

    messageContentStackView.addArrangedSubview(messageBubbleImageView)
    messageBubbleImageView.addSubview(messageLabel)
    messageLabel.snp.makeConstraints { make in
      make.verticalEdges.equalToSuperview().inset(12)
      make.horizontalEdges.equalToSuperview().inset(24)
    }
  }
}
