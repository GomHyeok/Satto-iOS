//
//  NavigationBar.swift
//  Base
//
//  Created by ttozzi on 8/10/25.
//

import DesignSystem
import SnapKit
import Then
import UIKit

public final class NavigationBar: UIView {

  public enum Style {
    case text(alignment: NSTextAlignment = .center)
    case image(UIImage)
  }

  private lazy var contentStackView = UIStackView().then {
    $0.axis = .horizontal
    $0.spacing = 8
    $0.distribution = .fill
  }
  private lazy var leftItemsSection = UIStackView().then {
    $0.axis = .horizontal
    $0.spacing = 8
  }
  private lazy var centerSection = UIStackView().then {
    $0.axis = .horizontal
  }
  private lazy var rightItemsSection = UIStackView().then {
    $0.axis = .horizontal
    $0.spacing = 8
  }
  private lazy var defaultTitleLabel = UILabel().then {
    $0.numberOfLines = 1
    $0.style = Typography.Body_16_B
    $0.textColor = STColors.gray1.color
    $0.textAlignment = .center
    $0.setContentHuggingPriority(UILayoutPriority(.zero), for: .horizontal)
  }
  private lazy var defaultImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
  }
  var title: String? {
    get { defaultTitleLabel.text }
    set { defaultTitleLabel.styledText = newValue }
  }

  init(style: Style, height: CGFloat) {
    super.init(frame: .zero)
    setupUI(with: style, height: height)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public func updateColor(_ color: UIColor) {
    defaultTitleLabel.textColor = color
    leftItemsSection.arrangedSubviews
      .compactMap { $0 as? NavigationBarItem }
      .forEach {
        $0.updateColor(color)
      }
    rightItemsSection.arrangedSubviews
      .compactMap { $0 as? NavigationBarItem }
      .forEach {
        $0.updateColor(color)
      }
  }

  private func setupUI(with style: Style, height: CGFloat) {
    addSubview(contentStackView)
    contentStackView.snp.makeConstraints { make in
      make.top.greaterThanOrEqualToSuperview()
      make.bottom.equalToSuperview()
      make.height.equalTo(height)
      make.horizontalEdges.equalToSuperview().inset(16)
    }

    contentStackView.addArrangedSubview(leftItemsSection)
    contentStackView.addArrangedSubview(centerSection)
    centerSection.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
    }
    centerSection.addArrangedSubview(defaultTitleLabel)
    centerSection.addArrangedSubview(defaultImageView)
    contentStackView.addArrangedSubview(rightItemsSection)

    switch style {
    case .text(let alignment):
      defaultImageView.isHidden = true
      defaultTitleLabel.textAlignment = alignment

    case .image(let image):
      defaultTitleLabel.isHidden = true
      defaultImageView.image = image.withTintColor(STColors.gray1.color)
      let spacer = UIView()
      centerSection.addArrangedSubview(spacer)
    }
  }

  func setLeftButtonItems(_ items: [any NavigationBarItem]) {
    leftItemsSection.arrangedSubviews.forEach {
      $0.removeFromSuperview()
    }
    items.forEach {
      leftItemsSection.addArrangedSubview($0)
    }
  }

  func setRightButtonItems(_ items: [any NavigationBarItem]) {
    rightItemsSection.arrangedSubviews.forEach {
      $0.removeFromSuperview()
    }
    items.forEach {
      rightItemsSection.addArrangedSubview($0)
    }
  }
}

@available(iOS 17.0, *)
#Preview("Text") {
  let navigationBar = NavigationBar(style: .text(alignment: .left), height: 56)
  navigationBar.snp.makeConstraints { make in
    make.height.equalTo(56)
  }
  navigationBar.backgroundColor = STColors.primary9.color
  navigationBar.title = "타이틀"
  navigationBar.setLeftButtonItems([NaivgationBarButtonItem.back])
  navigationBar.setRightButtonItems([NaivgationBarButtonItem.back])
  return navigationBar
}

@available(iOS 17.0, *)
#Preview("Image") {
  let image = STImages.navigationLogo.image
  let navigationBar = NavigationBar(style: .image(image), height: 56)
  navigationBar.snp.makeConstraints { make in
    make.height.equalTo(56)
  }
  navigationBar.backgroundColor = STColors.primary9.color
  navigationBar.setRightButtonItems([NaivgationBarButtonItem.back])
  return navigationBar
}
