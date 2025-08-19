//
//  OverallCollectionViewCell.swift
//  FeatureLayer
//
//  Created by 최재혁 on 8/12/25.
//

import Base
import DesignSystem
import UIKit

struct OverallCollectionViewCellModel {
  let modal: [OverallModalCollectionViewCellModel]
}

final class OverallCollectionViewCell: UICollectionViewCell {

  private var modalModels: [OverallModalCollectionViewCellModel] = []

  private lazy var contentStackView = UIStackView().then {
    $0.axis = .vertical
    $0.spacing = 12
    $0.alignment = .center
  }

  private lazy var titleStackView = UIStackView().then {
    $0.axis = .horizontal
    $0.spacing = 4
    $0.isLayoutMarginsRelativeArrangement = true
    $0.layoutMargins = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 0)
  }

  private lazy var titleLabel = UILabel().then {
    $0.style = Typography.Body_18_B
    $0.textColor = STColors.gray2.color
    $0.styledText = "종합 운세"
  }

  private lazy var modalCollectionView = UICollectionView(
    frame: .zero, collectionViewLayout: createLayout()
  ).then {
    $0.backgroundColor = .clear
    $0.isPagingEnabled = false
    $0.showsHorizontalScrollIndicator = false
    $0.delegate = self
    $0.dataSource = self
    $0.register(
      OverallModalCollectionViewCell.self,
      forCellWithReuseIdentifier: OverallModalCollectionViewCell.typeName)
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupUI() {
    contentView.addSubview(contentStackView)
    contentStackView.addArrangedSubview(titleStackView)
    contentStackView.addArrangedSubview(modalCollectionView)
    titleStackView.addArrangedSubview(titleLabel)

    contentStackView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }

    modalCollectionView.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview()
      make.height.equalTo(129)
    }

    titleStackView.snp.makeConstraints { make in
      make.leading.equalToSuperview()
    }
  }

  func update(with cellModel: OverallCollectionViewCellModel) {
    modalModels = cellModel.modal
    modalCollectionView.reloadData()
  }

  private func createLayout() -> UICollectionViewCompositionalLayout {
    let layout = UICollectionViewCompositionalLayout {
      sectionIndex, environment -> NSCollectionLayoutSection? in

      let itemSize = NSCollectionLayoutSize(
        widthDimension: .absolute(134),
        heightDimension: .estimated(200)
      )
      let item = NSCollectionLayoutItem(layoutSize: itemSize)

      let groupSize = NSCollectionLayoutSize(
        widthDimension: .absolute(134),
        heightDimension: .estimated(200)
      )

      let group = NSCollectionLayoutGroup.horizontal(
        layoutSize: groupSize,
        subitems: [item]
      )

      let section = NSCollectionLayoutSection(group: group)
      section.orthogonalScrollingBehavior = .continuous

      section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0)

      section.interGroupSpacing = 10

      return section
    }

    return layout
  }
}

extension OverallCollectionViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int)
    -> Int
  {
    return modalModels.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)
    -> UICollectionViewCell
  {
    guard
      let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: OverallModalCollectionViewCell.typeName,
        for: indexPath) as? OverallModalCollectionViewCell
    else {
      return UICollectionViewCell()
    }

    let model = modalModels[indexPath.item]
    cell.update(with: model)
    return cell
  }
}
