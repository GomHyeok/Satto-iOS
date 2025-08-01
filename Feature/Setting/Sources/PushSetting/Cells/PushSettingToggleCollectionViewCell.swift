//
//  PushSettingToggleCollectionViewCell.swift
//  Setting
//
//  Created by ttozzi on 7/31/25.
//

import Combine
import DesignSystem
import Extension
import SnapKit
import Then
import UIKit

final class PushSettingToggleCollectionViewCellModel: PushSettingCellModel {
  let title: String
  var isEnabled: Bool
  
  init(title: String, isEnabled: Bool) {
    self.title = title
    self.isEnabled = isEnabled
  }
}

final class PushSettingToggleCollectionViewCell: UICollectionViewCell {
  
  private lazy var contentStackView = UIStackView().then {
    $0.axis = .horizontal
    $0.spacing = .zero
    $0.alignment = .center
  }
  private lazy var titleLabel = UILabel().then {
    $0.style = Typography.Body_14_M
    $0.textColor = STColors.gray1.color
  }
  private lazy var toggle = Toggle()
  private var cellModel: PushSettingToggleCollectionViewCellModel?
  var toggleChangedPublisher: AnyPublisher<Bool, Never> {
    toggle.isOnPublisher
      .handleEvents(receiveOutput: { [weak self] isOn in
        self?.cellModel?.isEnabled = isOn
      })
      .eraseToAnyPublisher()
  }
  var cancellables = Set<AnyCancellable>()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    cancellables.removeAll()
  }
  
  private func setupUI() {
    contentView.backgroundColor = .clear
    
    contentView.addSubview(contentStackView)
    contentStackView.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.horizontalEdges.equalToSuperview()
      make.top.greaterThanOrEqualToSuperview()
      make.bottom.lessThanOrEqualToSuperview()
    }
    contentStackView.addArrangedSubview(titleLabel)
    contentStackView.addArrangedSubview(toggle)
  }
  
  func update(with cellModel: PushSettingToggleCollectionViewCellModel) {
    self.cellModel = cellModel
    titleLabel.styledText = cellModel.title
    toggle.isOn = cellModel.isEnabled
  }
}

@available(iOS 17.0, *)
#Preview {
  let cell = PushSettingToggleCollectionViewCell()
  cell.update(with: PushSettingToggleCollectionViewCellModel(
    title: "사또에게 알림 받기",
    isEnabled: true
  ))
  return cell
}
