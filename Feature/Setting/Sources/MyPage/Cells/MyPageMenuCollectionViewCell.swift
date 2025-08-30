//
//  MyPageMenuCollectionViewCell.swift
//  Setting
//
//  Created by ttozzi on 7/26/25.
//

import Base
import DesignSystem
import SnapKit
import Then
import UIKit

struct MyPageMenuCollectionViewCellModel {

  enum Style {
    case none
    case icon(UIImage)
    case text(String)
  }

  let style: Style
  let title: String
}

final class MyPageMenuCollectionViewCell: BaseCollectionViewCell {

  private lazy var contentStackView = UIStackView().then {
    $0.axis = .horizontal
    $0.spacing = .zero
  }
  private lazy var titleLabel = UILabel().then {
    $0.style = Typography.Body_14_M
    $0.numberOfLines = 1
    $0.setContentHuggingPriority(.init(.zero), for: .horizontal)
  }
  private lazy var accessoryStackView = UIStackView().then {
    $0.axis = .horizontal
    $0.spacing = .zero
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupUI() {
    backgroundColor = .clear
    contentStackView.backgroundColor = .clear

    contentView.addSubview(contentStackView)
    contentStackView.snp.makeConstraints { make in
      make.horizontalEdges.equalToSuperview().inset(20)
      make.centerY.equalToSuperview()
    }

    contentStackView.addArrangedSubview(titleLabel)
    contentStackView.addArrangedSubview(accessoryStackView)
  }

  func update(with cellModel: MyPageMenuCollectionViewCellModel) {
    resetAccessoryStackView()
    switch cellModel.style {
    case .none:
      break
    case .icon(let image):
      let imageView = UIImageView(image: image.withRenderingMode(.alwaysTemplate))
      imageView.tintColor = STColors.gray5.color
      imageView.contentMode = .scaleAspectFit
      imageView.snp.makeConstraints { make in
        make.size.equalTo(24)
      }
      accessoryStackView.addArrangedSubview(imageView)
    case .text(let text):
      let textLabel = UILabel().then {
        $0.style = Typography.Body_14_M
        $0.textColor = STColors.primary2.color
      }
      textLabel.styledText = text
      accessoryStackView.addArrangedSubview(textLabel)
    }
    titleLabel.styledText = cellModel.title
  }

  private func resetAccessoryStackView() {
    accessoryStackView.arrangedSubviews.forEach {
      accessoryStackView.removeArrangedSubview($0)
      $0.removeFromSuperview()
    }
  }
}

@available(iOS 17.0, *)
#Preview {
  let stackView = UIStackView().then {
    $0.axis = .vertical
    $0.spacing = .zero
  }
  let cellModels = [
    MyPageMenuCollectionViewCellModel(
      style: .none,
      title: "none"
    ),
    MyPageMenuCollectionViewCellModel(
      style: .icon(STImages.chevronRightS.image),
      title: "icon"
    ),
    MyPageMenuCollectionViewCellModel(
      style: .text("1.0.0"),
      title: "text"
    ),
  ]
  cellModels.forEach {
    let cell = MyPageMenuCollectionViewCell()
    cell.snp.makeConstraints { make in
      make.height.equalTo(48)
    }
    cell.update(with: $0)
    stackView.addArrangedSubview(cell)
  }
  return stackView
}
