//
//  Toast.swift
//  DesignSystemLayer
//
//  Created by 최재혁 on 8/18/25.
//

import SnapKit
import Then
import UIKit

public final class Toast: UIView {
  private lazy var contentStack = UIStackView().then {
    $0.axis = .horizontal
    $0.alignment = .leading
    $0.distribution = .fill
    $0.spacing = 8
    $0.backgroundColor = STColors.gray2.color
    $0.layer.cornerRadius = 10
    $0.layoutMargins = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
    $0.isLayoutMarginsRelativeArrangement = true
  }

  private lazy var checkImageView = UIImageView().then {
    $0.image = STImages.alertComponent.image
    $0.contentMode = .scaleAspectFit
  }

  private lazy var messageLabel = UILabel().then {
    $0.textColor = STColors.white.color
    $0.style = Typography.Body_14_M
    $0.textAlignment = .left
  }

  public init() {
    super.init(frame: .zero)
    setupUI()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupUI() {
    addSubview(contentStack)
    contentStack.addArrangedSubview(checkImageView)
    contentStack.addArrangedSubview(messageLabel)

    contentStack.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }

    checkImageView.snp.makeConstraints { make in
      make.width.height.equalTo(16)
    }
  }

  public func update(message: String) {
    self.messageLabel.styledText = message
  }
}

@available(iOS 17.0, *)
#Preview {
  let stackView = UIStackView().then {
    $0.axis = .vertical
    $0.spacing = 16
    $0.alignment = .center
  }

  let toast = Toast().then {
    $0.update(message: "정보 수정 성공했습니다.")
  }

  stackView.addArrangedSubview(toast)
  toast.snp.makeConstraints { make in
    make.width.equalTo(327)
    make.height.equalTo(44)
  }

  return stackView
}
