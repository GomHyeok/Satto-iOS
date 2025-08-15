//
//  AvoidNumberCollectionViewCell.swift
//  Home
//
//  Created by ttozzi on 8/9/25.
//

import DesignSystem
import Extension
import UIKit

struct AvoidNumberCollectionViewCellModel: RecommendationDetailCellModel {
  let items: [NumberCardItem]
}

final class AvoidNumberCollectionViewCell: UICollectionViewCell {
  
  private enum Constant {
    static let itemHeight: CGFloat = 122
    static let spacing: CGFloat = 6
  }
  
  private lazy var headerTitleLabel = UILabel().then {
    $0.style = Typography.Body_14_B
    $0.textColor = STColors.gray2.color
    $0.styledText = "제외 번호도 알려드릴게요"
  }
  private lazy var contentStackView = UIStackView().then {
    $0.spacing = 20
    $0.axis = .vertical
    $0.alignment = .fill
    $0.backgroundColor = STColors.white.color
    $0.layer.cornerRadius = 12
    $0.clipsToBounds = true
    $0.isLayoutMarginsRelativeArrangement = true
    $0.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
  }
  private lazy var descriptionLabel = UILabel().then {
    $0.style = Typography.Body_14_B.lineHeightMultiple(1.2)
    $0.textColor = STColors.gray2.color
    $0.numberOfLines = .zero
    $0.styledText = "혹시 다른 번호도 고민 중이라면,\n이 번호들은 피해주세요!"
  }
  private lazy var collectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: createCollectionViewLayout()
  ).then {
    $0.backgroundColor = .clear
    $0.showsHorizontalScrollIndicator = false
    $0.dataSource = self
    $0.register(
      NumberCardItemCollectionViewCell.self,
      forCellWithReuseIdentifier: NumberCardItemCollectionViewCell.typeName
    )
  }
  private var cellModel: AvoidNumberCollectionViewCellModel?
  
  private func createCollectionViewLayout() -> UICollectionViewLayout {
    let itemSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(0.5),
      heightDimension: .absolute(Constant.itemHeight)
    )
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    
    let groupSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .absolute(Constant.itemHeight)
    )
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
    group.interItemSpacing = .fixed(Constant.spacing)
    
    let section = NSCollectionLayoutSection(group: group)
    section.interGroupSpacing = Constant.spacing
    section.orthogonalScrollingBehavior = .continuous
    
    return UICollectionViewCompositionalLayout(section: section)
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupUI() {
    contentView.backgroundColor = .clear
    
    contentView.addSubview(headerTitleLabel)
    headerTitleLabel.snp.makeConstraints { make in
      make.top.leading.trailing.equalToSuperview()
    }
    
    contentView.addSubview(contentStackView)
    contentStackView.snp.makeConstraints { make in
      make.top.equalTo(headerTitleLabel.snp.bottom).offset(8)
      make.leading.trailing.bottom.equalToSuperview()
    }
    
    contentStackView.addArrangedSubview(descriptionLabel)
    descriptionLabel.snp.makeConstraints { make in
      make.height.equalTo(42)
    }
    
    contentStackView.addArrangedSubview(collectionView)
    collectionView.snp.makeConstraints { make in
      make.height.equalTo(Constant.itemHeight)
    }
  }
  
  func update(with model: AvoidNumberCollectionViewCellModel) {
    cellModel = model
    collectionView.reloadData()
  }
}

extension AvoidNumberCollectionViewCell: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return cellModel?.items.count ?? .zero
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: NumberCardItemCollectionViewCell.typeName,
      for: indexPath
    )
    if let cell = cell as? NumberCardItemCollectionViewCell,
       let item = cellModel?.items[safe: indexPath.item] {
      cell.update(with: item)
    }
    return cell
  }
}

@available(iOS 17.0, *)
#Preview {
  let cellModel = AvoidNumberCollectionViewCellModel(
    items: [
      .init(title: "수(水) 기운과\n상충하는 숫자", numbers: [9, 11, 18]),
      .init(title: "최근 100회 동안\n거의 안 나온 숫자", numbers: [24, 33]),
      .init(title: "숫자", numbers: [44]),
    ]
  )
  let cell = AvoidNumberCollectionViewCell()
  cell.update(with: cellModel)
  cell.snp.makeConstraints { make in
    make.height.equalTo(253)
  }
  return cell
}
