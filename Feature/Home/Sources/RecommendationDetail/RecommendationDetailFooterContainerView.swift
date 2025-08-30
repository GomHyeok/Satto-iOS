//
//  RecommendationDetailFooterContainerView.swift
//  Home
//
//  Created by ttozzi on 8/15/25.
//

import DesignSystem
import SnapKit
import Then
import UIKit

final class RecommendationDetailFooterContainerView: UIView {

  private let gradientLayer = CAGradientLayer()
  private lazy var gradientView = UIView().then {
    let gradient = CAGradientLayer()
    gradientLayer.colors = [
      STColors.primary9.color.withAlphaComponent(0).cgColor,
      STColors.primary9.color.cgColor,
    ]
    gradientLayer.locations = [0, 1]
    gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.25)
    gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.75)
    $0.layer.addSublayer(gradientLayer)
  }
  private lazy var contentStackView = UIStackView().then {
    $0.axis = .horizontal
    $0.spacing = 10
    $0.distribution = .fillEqually
    $0.alignment = .top
    $0.backgroundColor = STColors.primary9.color
    $0.isLayoutMarginsRelativeArrangement = true
    $0.layoutMargins = UIEdgeInsets(top: .zero, left: 24, bottom: .zero, right: 24)
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
    gradientLayer.frame = gradientView.bounds
  }

  private func setupUI() {
    addSubview(gradientView)
    gradientView.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.height.equalTo(32)
      make.horizontalEdges.equalToSuperview()
    }
    addSubview(contentStackView)
    contentStackView.snp.makeConstraints { make in
      make.top.equalTo(gradientView.snp.bottom)
      make.horizontalEdges.equalToSuperview()
      make.bottom.equalToSuperview()
    }
  }

  func update(buttons: [UIView]) {
    contentStackView.arrangedSubviews.forEach {
      $0.removeFromSuperview()
    }
    buttons.forEach {
      contentStackView.addArrangedSubview($0)
    }
  }
}

@available(iOS 17.0, *)
#Preview {
  let view = RecommendationDetailFooterContainerView()
  view.snp.makeConstraints { make in
    make.height.equalTo(104)
    make.width.equalTo(390)
  }
  let dummyButtons = (0..<2).map { _ in
    let dummy = UIView()
    dummy.backgroundColor = .gray
    dummy.snp.makeConstraints { make in
      make.height.equalTo(48)
    }
    return dummy
  }
  view.update(buttons: dummyButtons)
  return view
}
