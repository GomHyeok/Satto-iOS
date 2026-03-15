//
//  RankPlaceCell.swift
//  FeatureLayer
//
//  Created by 최재혁 on 3/12/26.
//

import Base
import DesignSystem
import UIKit
import Then

struct RankPlaceCellModel {
  let id: String
  let index: Int
  let title: String
  let address: String
  let count: Int
  let auto: Int
  let manual: Int
  let semi: Int
}

protocol RankPlaceCellDelegate: AnyObject {
  func rankPlaceCellDidTap(_ model: RankPlaceCellModel)
}

final class RankPlaceCell: BaseCollectionViewCell {
  
  weak var delegate: RankPlaceCellDelegate?
  
  private var model: RankPlaceCellModel?
  
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
  
  private lazy var countStackView: UIStackView = UIStackView().then {
    $0.axis = .horizontal
    $0.spacing = 4
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
  
  private lazy var splitView = UIView().then {
    $0.backgroundColor = STColors.gray8.color
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension RankPlaceCell {
  private func setupUI() {
    contentView.addSubview(contentStackView)
    contentView.addSubview(splitView)
    contentStackView.addArrangedSubview(textStackView)
    contentStackView.addArrangedSubview(cellTouchButton)
    textStackView.addArrangedSubview(titleStackView)
    textStackView.addArrangedSubview(addressLabel)
    textStackView.addArrangedSubview(countStackView)
    titleStackView.addArrangedSubview(numTitleLabel)
    titleStackView.addArrangedSubview(titleLabel)
    
    contentStackView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    
    cellTouchButton.snp.makeConstraints { make in
      make.width.equalTo(24)
      make.height.equalTo(24)
    }
    
    splitView.snp.makeConstraints {make in
      make.height.equalTo(1)
      make.leading.trailing.equalToSuperview().offset(24)
      make.bottom.equalToSuperview()
    }
  }
  
  func update(with cellModel: RankPlaceCellModel) {
    self.model = cellModel
    numTitleLabel.styledText = "\(cellModel.index + 1)"
    titleLabel.styledText = cellModel.title
    addressLabel.styledText = cellModel.address
    countStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    makeCountView(text: "당첨횟수", count: cellModel.count)
    makeCountView(text: "자동", count: cellModel.auto)
    makeCountView(text: "수동", count: cellModel.manual)
    makeCountView(text: "반자동", count: cellModel.semi)
  }
  
  private func makeCountView(text : String, count: Int) {
    let countLabel = CountView()
    countLabel.update(title: text, count: "\(count)")
    countStackView.addArrangedSubview(countLabel)
  }
  
  @objc private func cellTapped() {
    guard let model = model else { return }
    delegate?.rankPlaceCellDidTap(model)
  }
}

@available(iOS 17.0, *)
#Preview {
  let cellModel = RankPlaceCellModel(
    id: "0",
    index: 0,
    title: "집가고 싶다",
    address: "서울특별시 종로구 종로 1",
    count: 100,
    auto: 50,
    manual: 30,
    semi: 20
  )
  
  let cell = RankPlaceCell(frame: .zero)
  
  cell.update(with: cellModel)
  
  return cell
}
