//
//  RecommendationLoadingView.swift
//  Home
//
//  Created by ttozzi on 8/17/25.
//

import Auth
import Base
import DIInjector
import DesignSystem
import UIKit

final class RecommendationLoadingView: UIView {

  private let gradientLayer = CAGradientLayer().then {
    $0.colors = [
      UIColor(hexString: "#312354").cgColor,
      STColors.primary3.color.cgColor,
    ]
    $0.locations = [0, 1]
    $0.startPoint = CGPoint(x: 0.5, y: 0.25)
    $0.endPoint = CGPoint(x: 0.5, y: 0.75)
  }
  private lazy var contentStackView = UIStackView().then {
    $0.axis = .vertical
    $0.spacing = .zero
    $0.alignment = .center
  }
  private lazy var titleLabel = UILabel().then {
    $0.style = Typography.Body_14_M.color(STColors.primary5.color)
  }
  private lazy var descriptionLabel = UILabel().then {
    $0.style = Typography.Heading_24_SB
      .color(STColors.white.color)
      .lineHeightMultiple(1.2)
      .alignment(.center)
    $0.styledText = "그대에게 딱 맞는\n번호를 추천 중이라네..."
    $0.numberOfLines = .zero
  }
  private lazy var loadingImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFill
    $0.image = STImages.lottoLoading.image
  }
  private let duration: TimeInterval
  @Injected var userDataManager: UserDataManager

  init(duration: TimeInterval) {
    self.duration = duration
    super.init(frame: .zero)
    setupUI()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    gradientLayer.frame = bounds
  }

  private func setupUI() {
    layer.insertSublayer(gradientLayer, at: .zero)

    addSubview(contentStackView)
    contentStackView.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.horizontalEdges.equalToSuperview()
    }

    contentStackView.addArrangedSubview(titleLabel)
    contentStackView.setCustomSpacing(8, after: titleLabel)

    contentStackView.addArrangedSubview(descriptionLabel)
    contentStackView.setCustomSpacing(55, after: descriptionLabel)

    contentStackView.addArrangedSubview(loadingImageView)
    loadingImageView.snp.makeConstraints { make in
      make.width.equalToSuperview()
    }

    titleLabel.styledText =
      if let username = userDataManager.user?.name {
        "\(username)의 사주 분석 완료"
      } else {
        "사주 분석 완료"
      }
  }

  func play() {
    UIView.animateKeyframes(
      withDuration: duration,
      delay: 0,
      options: [.calculationModeLinear, .allowUserInteraction, .beginFromCurrentState]
    ) {
      // 0.00~0.25: fade-out
      UIView.addKeyframe(withRelativeStartTime: 0.00, relativeDuration: 0.25) {
        self.loadingImageView.alpha = 0.2
      }
      // 0.25~0.50: fade-in
      UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.25) {
        self.loadingImageView.alpha = 1.0
      }
      // 0.50~0.75: fade-out
      UIView.addKeyframe(withRelativeStartTime: 0.50, relativeDuration: 0.25) {
        self.loadingImageView.alpha = 0.2
      }
      // 0.75~1.00: fade-in
      UIView.addKeyframe(withRelativeStartTime: 0.75, relativeDuration: 0.25) {
        self.loadingImageView.alpha = 1.0
      }
    }
  }
}
