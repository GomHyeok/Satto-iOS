//
//  Banner.swift
//  DesignSystem
//
//  Created by ttozzi on 7/24/25.
//

import SnapKit
import Then
import UIKit

public final class Banner: UIView {

  public enum Style: CaseIterable {
    case notice
    case error
    case success
    case warning

    fileprivate var backgroundColor: UIColor {
      switch self {
      case .notice:
        return STColors.primary8.color
      case .error:
        return STColors.red9.color
      case .success:
        return STColors.green9.color
      case .warning:
        return STColors.orange9.color
      }
    }

    fileprivate var icon: UIImage? {
      switch self {
      case .notice:
        return STImages.info.image
      case .error:
        return STImages.alertTriangle.image
      case .success:
        return STImages.checkCircle2.image
      case .warning:
        return STImages.alertCircle.image
      }
    }

    fileprivate var iconTintColor: UIColor {
      switch self {
      case .notice:
        return STColors.primary2.color
      case .error:
        return STColors.red3.color
      case .success:
        return STColors.green3.color
      case .warning:
        return STColors.orange3.color
      }
    }
  }

  private lazy var contentStackView = UIStackView().then {
    $0.spacing = 8
    $0.alignment = .top
  }
  private lazy var iconImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
    $0.setContentHuggingPriority(.defaultLow, for: .vertical)
  }
  private lazy var textStackView = UIStackView().then {
    $0.spacing = 4
    $0.axis = .vertical
    $0.alignment = .leading
    $0.setContentCompressionResistancePriority(.required, for: .vertical)
  }
  private lazy var titleLabel = UILabel().then {
    $0.style = Typography.Body_14_M
    $0.textColor = DesignSystemAsset.Colors.gray1.color
  }
  private lazy var descriptionLabel = UILabel().then {
    $0.style = Typography.Caption_12_R
    $0.textColor = DesignSystemAsset.Colors.gray4.color
    $0.numberOfLines = .zero
  }

  public init(style: Style? = nil) {
    super.init(frame: .zero)
    setupUI()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupUI() {
    layer.cornerRadius = 8
    layer.masksToBounds = true

    addSubview(contentStackView)
    contentStackView.snp.makeConstraints { make in
      make.verticalEdges.equalToSuperview().inset(12)
      make.leading.equalToSuperview().inset(12)
      make.trailing.equalToSuperview().inset(16)
    }
    contentStackView.addArrangedSubview(iconImageView)
    iconImageView.snp.makeConstraints { make in
      make.width.equalTo(16)
      make.height.equalTo(22)
    }
    contentStackView.addArrangedSubview(textStackView)

    textStackView.addArrangedSubview(titleLabel)
    titleLabel.snp.makeConstraints { make in
      make.height.greaterThanOrEqualTo(21)
    }
    textStackView.addArrangedSubview(descriptionLabel)
    titleLabel.snp.makeConstraints { make in
      make.height.greaterThanOrEqualTo(18)
    }
  }

  public func update(title: String, description: String? = nil) {
    titleLabel.styledText = title
    descriptionLabel.styledText = description
    descriptionLabel.isHidden = description == nil
  }

  public func update(style: Style) {
    backgroundColor = style.backgroundColor
    iconImageView.image = style.icon?.withRenderingMode(.alwaysTemplate)
    iconImageView.tintColor = style.iconTintColor
  }
}

@available(iOS 17.0, *)
#Preview {
  let stackView = UIStackView().then {
    $0.axis = .vertical
    $0.spacing = 8
  }

  Banner.Style.allCases.forEach {
    let titleOnlyBanner = Banner()
    titleOnlyBanner.update(style: $0)
    titleOnlyBanner.update(title: "Title")
    stackView.addArrangedSubview(titleOnlyBanner)
    let banner = Banner()
    banner.update(style: $0)
    banner.update(title: "Title", description: "Enter a secondary description for your guide")
    stackView.addArrangedSubview(banner)
  }
  return stackView
}
