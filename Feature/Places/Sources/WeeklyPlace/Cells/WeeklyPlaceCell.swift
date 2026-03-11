//
//  WeeklyPlaceCell.swift
//  FeatureLayer
//
//  Created by 최재혁 on 3/10/26.
//

import Base
import DesignSystem
import Foundation
import SnapKit
import Then
import UIKit

struct WeeklyPlaceCellModel {
  let id: Int
  let title: String
  let address: String
}

protocol WeeklyPlaceCellDelegate: AnyObject {
  func weeklyPlaceCellDidTap(_ model: WeeklyPlaceCellModel)
}

final class WeeklyPlaceCell: BaseCollectionViewCell {
  
  weak var delegate: WeeklyPlaceCellDelegate?
  
  private var model: WeeklyPlaceCellModel?
  
  private lazy var contentStackView = UIStackView().then {
    $0.axis = .horizontal
    $0.spacing = 0
    $0.alignment = .center
    $0.isLayoutMarginsRelativeArrangement = true
    $0.layoutMargins = UIEdgeInsets(top: 16, left: 24, bottom: 16, right: 24)
  }
  
  private lazy var textStackView: UIStackView = UIStackView().then {
    $0.axis = .vertical
    $0.spacing = 6
    $0.alignment = .leading
  }
  
  private lazy var titleStackView: UIStackView = UIStackView().then {
    $0.axis = .horizontal
    $0.spacing = 6
    $0.alignment = .center
  }
  
  private lazy var numTitleLabel = UILabel().then {
    $0.style = Typography.Body_16_SB
    $0.textColor = STColors.primary2.color
  }
  
  private lazy var titleLabel = UILabel().then {
    $0.style = Typography.Body_16_SB
    $0.textColor = STColors.gray1.color
  }
  
  private lazy var addressLabel = UILabel().then {
    $0.style = Typography.Caption_12_M
    $0.textColor = STColors.gray3.color
  }
  
  private lazy var cellTouchButton = UIButton().then {
    $0.setImage(STImages.chevronRightM.image, for: .normal)
    $0.addTarget(self, action: #selector(cellTapped), for: .touchUpInside)
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension WeeklyPlaceCell {
  private func setupUI() {
    contentView.addSubview(contentStackView)
    contentStackView.addArrangedSubview(textStackView)
    contentStackView.addArrangedSubview(cellTouchButton)
    textStackView.addArrangedSubview(titleStackView)
    textStackView.addArrangedSubview(addressLabel)
    titleStackView.addArrangedSubview(numTitleLabel)
    titleStackView.addArrangedSubview(titleLabel)
    
    contentStackView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    
    cellTouchButton.snp.makeConstraints { make in
      make.width.equalTo(24)
      make.height.equalTo(24)
    }
  }
  
  func update(with cellModel: WeeklyPlaceCellModel) {
    self.model = cellModel
    numTitleLabel.text = "\(cellModel.id + 1)."
    titleLabel.text = cellModel.title
    addressLabel.text = cellModel.address
  }
  
  @objc private func cellTapped() {
    guard let model = model else { return }
    delegate?.weeklyPlaceCellDidTap(model)
  }
}

@available(iOS 17.0, *)
#Preview {
  let cellModel = WeeklyPlaceCellModel(
    id: 1,
    title: "서울숲",
    address: "서울 성동구 뚝섬로 273 (성수동1가)",
  )

  let cell = WeeklyPlaceCell()
  cell.update(with: cellModel)

  return cell
}
