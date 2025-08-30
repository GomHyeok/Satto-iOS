//
//  TooltipView.swift
//  Home
//
//  Created by ttozzi on 8/15/25.
//

import DesignSystem
import UIKit

final class TooltipView: UIView {

  private enum Constant {
    static let verticalPadding: CGFloat = 12
    static let horizontalPadding: CGFloat = 16
  }

  private lazy var contentStackView = UIStackView().then {
    $0.axis = .vertical
    $0.alignment = .center
    $0.spacing = .zero
    $0.layer.cornerRadius = 10
    $0.clipsToBounds = true
    $0.isLayoutMarginsRelativeArrangement = true
    $0.layoutMargins = UIEdgeInsets(
      top: Constant.verticalPadding,
      left: Constant.horizontalPadding,
      bottom: Constant.verticalPadding,
      right: Constant.horizontalPadding
    )
    $0.backgroundColor = STColors.gray2.color
  }
  private lazy var arrowImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
    $0.image = STImages.arrow.image.withRenderingMode(.alwaysTemplate)
    $0.tintColor = STColors.gray2.color
  }
  private lazy var textLabel = UILabel().then {
    $0.style = Typography.Body_14_M
    $0.textColor = STColors.white.color
  }
  var text: String? {
    get { textLabel.text }
    set { textLabel.styledText = newValue }
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupUI() {
    addSubview(contentStackView)
    contentStackView.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.horizontalEdges.equalToSuperview()
      make.bottom.equalToSuperview().inset(6)
    }

    addSubview(arrowImageView)
    arrowImageView.snp.makeConstraints { make in
      make.top.equalTo(contentStackView.snp.bottom)
      make.centerX.equalTo(contentStackView)
      make.height.equalTo(6)
      make.width.equalTo(13)
    }

    contentStackView.addArrangedSubview(textLabel)
  }
}

@available(iOS 17.0, *)
#Preview {
  let view = TooltipView()
  view.snp.makeConstraints { make in
    make.width.equalTo(327)
    make.height.equalTo(50)
  }
  view.text = "결과가 나왔소! 번호 보러 오시오."
  return view
}
