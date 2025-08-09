//
//  RoundTintedChip.swift
//  DesignSystemLayer
//
//  Created by 최재혁 on 8/9/25.
//

import UIKit

public final class RoundTintedChip: UIView {
  public enum Style: CaseIterable {
    case primary, black, gray, red, orange, yellow, green, blue

    fileprivate var backgroudColor: UIColor {
      switch self {
      case .primary: return STColors.primary7.color
      case .black, .gray: return STColors.gray8.color
      case .red: return STColors.red8.color
      case .orange: return STColors.orange8.color
      case .yellow: return STColors.yellow8.color
      case .green: return STColors.gray8.color
      case .blue: return STColors.blue8.color
      }
    }

    fileprivate var tintColor: UIColor {
      switch self {
      case .primary: return STColors.primary2.color
      case .black: return STColors.gray2.color
      case .gray: return STColors.gray5.color
      case .red: return STColors.red3.color
      case .orange: return STColors.orange2.color
      case .yellow: return STColors.yellow1.color
      case .green: return STColors.green3.color
      case .blue: return STColors.blue3.color
      }
    }

    fileprivate var borderColor: UIColor {
      switch self {
      case .primary: return STColors.primary7.color
      case .black, .gray: return STColors.gray8.color
      case .red: return STColors.red8.color
      case .orange: return STColors.orange8.color
      case .yellow: return STColors.yellow8.color
      case .green: return STColors.green8.color
      case .blue: return STColors.blue8.color
      }
    }
  }

  private lazy var contentStackView = UIStackView().then {
    $0.axis = .horizontal
    $0.spacing = 2
    $0.alignment = .center
  }

  private lazy var arrowLeftView = UIImageView().then {
    $0.image = STImages.iconArrow.image
    $0.contentMode = .scaleAspectFit
  }

  private lazy var arrowRightView = UIImageView().then {
    $0.image = STImages.iconArrow.image
    $0.contentMode = .scaleAspectFit
    $0.transform = CGAffineTransform(rotationAngle: .pi)
  }

  private lazy var titleLabel = UILabel().then {
    $0.style = Typography.Body_14_SB
    $0.textAlignment = .center
  }

  public init() {
    super.init(frame: .zero)
    setupUI()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupUI() {
    self.addSubview(contentStackView)
    contentStackView.addArrangedSubview(arrowLeftView)
    contentStackView.addArrangedSubview(titleLabel)
    contentStackView.addArrangedSubview(arrowRightView)

    contentStackView.snp.makeConstraints { make in
      make.verticalEdges.equalToSuperview().inset(6)
      make.leading.equalToSuperview().inset(10)
      make.trailing.equalToSuperview().inset(10)
    }

    arrowLeftView.snp.makeConstraints { make in
      make.width.height.equalTo(16)
    }

    arrowLeftView.isHidden = true
    arrowRightView.isHidden = true

    self.layer.cornerRadius = 14
    self.layer.masksToBounds = true
  }

  public func update(text: String, icon: UIImage? = nil) {
    titleLabel.styledText = text
    arrowLeftView.isHidden = icon == nil
    arrowRightView.isHidden = icon == nil

    if let icon = icon {
      let template = icon.withRenderingMode(.alwaysTemplate)
      arrowLeftView.image = template
      arrowRightView.image = template
    }
  }

  public func update(style: Style) {
    backgroundColor = style.backgroudColor
    titleLabel.textColor = style.tintColor
    arrowLeftView.tintColor = style.tintColor
    arrowRightView.tintColor = style.tintColor
    self.layer.borderColor = style.borderColor.cgColor
    self.layer.borderWidth = 1.0
  }
}

@available(iOS 17.0, *)
#Preview {
  let stackView = UIStackView().then {
    $0.axis = .vertical
    $0.spacing = 8
  }

  RoundTintedChip.Style.allCases.forEach {
    let titleOnly = RoundTintedChip()
    titleOnly.update(text: "Round Tinted Chip")
    titleOnly.update(style: $0)
    stackView.addArrangedSubview(titleOnly)
    let chip = RoundTintedChip()
    chip.update(text: "Round Tinted Chip", icon: STImages.iconArrow.image)
    chip.update(style: $0)
    stackView.addArrangedSubview(chip)
  }

  return stackView
}
