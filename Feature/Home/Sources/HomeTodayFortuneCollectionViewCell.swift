//
//  HomeTodayFortuneCollectionViewCell.swift
//  Home
//
//  Created by ttozzi on 7/31/25.
//

import DesignSystem
import UIKit

struct HomeTodayFortuneCollectionViewCellModel: HomeCellModel {
  let items: [FortuneItemCollectionViewCellModel]
}

final class HomeTodayFortuneCollectionViewCell: UICollectionViewCell {
  
  private lazy var contentStackView = UIStackView().then {
    $0.axis = .vertical
    $0.spacing = 20
    $0.alignment = .center
  }
  private lazy var titleLabel = UILabel().then {
    $0.style = Typography.Body_18_B
    $0.textColor = STColors.black.color
    let attachment = NSTextAttachment()
    attachment.image = STImages.clover.image
    attachment.bounds = CGRect(x: 0, y: -6, width: 24, height: 24)
    let space = NSMutableAttributedString(string: " ")
    space.addAttribute(.kern, value: 1, range: NSRange(location: 0, length: 1))
    let attributedText = NSMutableAttributedString()
    attributedText.append(NSAttributedString(attachment: attachment))
    attributedText.append(space)
    attributedText.append("오늘의 운세".set(style: Typography.Body_18_B))
    attributedText.append(space)
    attributedText.append(NSAttributedString(attachment: attachment))
    $0.attributedText = attributedText
  }
  private lazy var collectionView = UICollectionView(
    frame: .zero, collectionViewLayout: createLayout()
  ).then {
    $0.backgroundColor = .clear
    $0.dataSource = self
    $0.register(
      FortuneItemCollectionViewCell.self,
      forCellWithReuseIdentifier: FortuneItemCollectionViewCell.typeName
    )
  }
  private var cellModel: HomeTodayFortuneCollectionViewCellModel?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupUI() {
    contentView.backgroundColor = STColors.white.color
    contentView.layer.cornerRadius = 12
    contentView.clipsToBounds = true
    
    contentView.addSubview(contentStackView)
    contentStackView.snp.makeConstraints { make in
      make.top.equalToSuperview().inset(24)
      make.horizontalEdges.equalToSuperview().inset(20)
      make.bottom.equalToSuperview().inset(20)
    }
    
    contentStackView.addArrangedSubview(titleLabel)
    
    contentStackView.addArrangedSubview(collectionView)
    collectionView.snp.makeConstraints { make in
      make.horizontalEdges.equalToSuperview()
    }
  }
  
  private func createLayout() -> UICollectionViewLayout {
    let spacing: CGFloat = 20
    
    let itemSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(0.5),
      heightDimension: .estimated(179)
    )
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    
    let groupSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .estimated(179)
    )
    let group = NSCollectionLayoutGroup.horizontal(
      layoutSize: groupSize,
      subitems: [item]
    )
    group.interItemSpacing = .fixed(spacing)
    
    let section = NSCollectionLayoutSection(group: group)
    section.interGroupSpacing = 40
    
    return UICollectionViewCompositionalLayout(section: section)
  }
  
  func update(with model: HomeTodayFortuneCollectionViewCellModel) {
    self.cellModel = model
    collectionView.reloadData()
  }
}

extension HomeTodayFortuneCollectionViewCell: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return cellModel?.items.count ?? .zero
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: FortuneItemCollectionViewCell.typeName, for: indexPath)
    if let cell = cell as? FortuneItemCollectionViewCell,
       let item = cellModel?.items[safe: indexPath.item] {
      cell.update(with: item)
    }
    return cell
  }
}

@available(iOS 17.0, *)
#Preview {
  let cellModel = HomeTodayFortuneCollectionViewCellModel(
    items: [
      FortuneItemCollectionViewCellModel(
        title: "귀인의 초성",
        imageURL: "",
        message: "연락 오면 무조건 받아라"
      ),
      FortuneItemCollectionViewCellModel(
        title: "행운의 오브제",
        imageURL: "",
        message: "보이면 낚으시길"
      ),
      FortuneItemCollectionViewCellModel(
        title: "절호의 타이밍",
        imageURL: "",
        message: "이 시간에 연락하면 안읽씹도 회신 옴"
      ),
      FortuneItemCollectionViewCellModel(
        title: "오늘의 금기",
        imageURL: "",
        message: "카페인 과다 섭취 금지"
      )
    ]
  )
  let cell = HomeTodayFortuneCollectionViewCell()
  cell.snp.makeConstraints { make in
    make.width.equalTo(335)
    make.height.equalTo(510)
  }
  cell.update(with: cellModel)
  return cell
}
