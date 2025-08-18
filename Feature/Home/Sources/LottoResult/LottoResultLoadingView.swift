//
//  LottoResultLoadingView.swift
//  Home
//
//  Created by ttozzi on 8/17/25.
//

import DesignSystem
import Lottie
import UIKit

final class LottoResultLoadingView: UIView {

  private let gradientLayer = CAGradientLayer().then {
    $0.colors = [
      UIColor(hexString: "#581AAF").cgColor,
      STColors.primary3.color.cgColor,
    ]
    $0.locations = [0, 1]
    $0.startPoint = CGPoint(x: 0.5, y: 0.25)
    $0.endPoint = CGPoint(x: 0.5, y: 0.75)
  }
  private lazy var contentStackView = UIStackView().then {
    $0.axis = .vertical
    $0.spacing = 20
    $0.alignment = .center
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    gradientLayer.frame = bounds
  }

  func play() {
    contentStackView.arrangedSubviews.forEach {
      $0.removeFromSuperview()
    }
    Task { @MainActor in
      guard let textAnimationView = await LottieAnimations.loadAnimation(.lottoResultText),
        let pigAnimationView = await LottieAnimations.loadAnimation(.lottoResultPig)
      else { return }
      pigAnimationView.alpha = 0
      pigAnimationView.loopMode = .loop

      contentStackView.addArrangedSubview(pigAnimationView)
      contentStackView.addArrangedSubview(textAnimationView)

      textAnimationView.play { completed in
        UIView.animate(withDuration: 0.5) {
          pigAnimationView.alpha = 1
          pigAnimationView.play()
        }
      }
    }
  }

  private func setupUI() {
    layer.insertSublayer(gradientLayer, at: .zero)

    addSubview(contentStackView)
    contentStackView.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.centerX.equalToSuperview()
      make.leading.greaterThanOrEqualToSuperview()
      make.trailing.lessThanOrEqualToSuperview()
    }
  }
}
