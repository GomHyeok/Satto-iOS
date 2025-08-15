//
//  TabBarItem.swift
//  Base
//
//  Created by ttozzi on 8/14/25.
//

import DesignSystem
import SnapKit
import Then
import UIKit

final class TabBarItem: UIView {

  private enum Constant {
    static let selectedColor = STColors.primary2.color
    static let unselectedColor = STColors.gray5.color
  }

  private lazy var contentStackView = UIStackView().then {
    $0.axis = .vertical
    $0.spacing = 4
    $0.alignment = .center
  }
  private lazy var imageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
  }
  private lazy var titleLabel = UILabel()
  var image: UIImage? {
    get { imageView.image }
    set { imageView.image = newValue?.withRenderingMode(.alwaysTemplate) }
  }
  var title: String? {
    get { titleLabel.text }
    set { titleLabel.styledText = newValue }
  }
  var isSelected: Bool = false {
    didSet {
      update(selected: isSelected)
    }
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
      make.centerY.equalToSuperview()
      make.leading.greaterThanOrEqualToSuperview()
      make.bottom.lessThanOrEqualToSuperview()
      make.horizontalEdges.equalToSuperview()
    }
    contentStackView.addArrangedSubview(imageView)
    imageView.snp.makeConstraints { make in
      make.size.equalTo(24)
    }
    contentStackView.addArrangedSubview(titleLabel)
  }

  private func update(selected: Bool) {
    if selected {
      imageView.tintColor = Constant.selectedColor
      titleLabel.textColor = Constant.selectedColor
      titleLabel.style = Typography.Caption_12_B
    } else {
      imageView.tintColor = Constant.unselectedColor
      titleLabel.textColor = Constant.unselectedColor
      titleLabel.style = Typography.Caption_12_R
    }
  }
}

@available(iOS 17.0, *)
#Preview {
  let content = UIStackView().then {
    $0.axis = .horizontal
  }
  let selectedItem = TabBarItem()
  selectedItem.snp.makeConstraints { make in
    make.width.equalTo(88)
    make.height.equalTo(72)
  }
  selectedItem.image = STImages.home.image
  selectedItem.title = "홈"
  selectedItem.isSelected = true
  content.addArrangedSubview(selectedItem)

  let unselectedItem = TabBarItem()
  unselectedItem.snp.makeConstraints { make in
    make.width.equalTo(88)
    make.height.equalTo(72)
  }
  unselectedItem.image = STImages.home.image
  unselectedItem.title = "홈"
  unselectedItem.isSelected = false
  content.addArrangedSubview(unselectedItem)
  return content
}
