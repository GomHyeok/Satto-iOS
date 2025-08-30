//
//  HomeBackgroundView.swift
//  Home
//
//  Created by ttozzi on 8/18/25.
//

import DesignSystem
import UIKit

final class HomeBackgroundView: UIView {

  private let gradientLayer = CAGradientLayer().then {
    $0.colors = [
      UIColor(hexString: "#ECE2FF").cgColor,
      UIColor(hexString: "#F4F3F5").cgColor,
    ]
    $0.locations = [0, 1]
    $0.startPoint = CGPoint(x: 0.5, y: 0.5)
    $0.endPoint = CGPoint(x: 0.5, y: 1)
  }
  private lazy var patternImageView1 = UIImageView().then {
    $0.contentMode = .scaleAspectFit
    $0.image = STImages.homePattern1.image
  }
  private lazy var patternImageView2 = UIImageView().then {
    $0.contentMode = .scaleAspectFit
    $0.image = STImages.homePattern2.image
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

  private func setupUI() {
    layer.insertSublayer(gradientLayer, at: .zero)

    addSubview(patternImageView1)
    patternImageView1.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(27)
      make.leading.equalToSuperview()
    }

    addSubview(patternImageView2)
    patternImageView2.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(155)
      make.trailing.equalToSuperview()
    }
  }
}
