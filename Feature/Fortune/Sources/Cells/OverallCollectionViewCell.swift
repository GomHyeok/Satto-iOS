//
//  OverallCollectionViewCell.swift
//  FeatureLayer
//
//  Created by 최재혁 on 8/12/25.
//

import UIKit
import DesignSystem
import Base

struct OverallCollectionViewCellModel {
    let title: String
    let modal : [OverallModalCollectionViewCellModel]
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
        titleLabel.styledText = cellModel.title
        modalModels = cellModel.modal
        modalCollectionView.reloadData()
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, environment -> NSCollectionLayoutSection? in

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

extension OverallCollectionViewCell : UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return modalModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: OverallModalCollectionViewCell.typeName,
            for: indexPath) as? OverallModalCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let model = modalModels[indexPath.item]
        cell.update(with: model)
        return cell
    }
}

@available(iOS 17.0, *)
#Preview {
    let containerView = UIView().then {
        $0.backgroundColor = .systemBackground
    }
    
    let cell = OverallCollectionViewCell(frame: .zero)
    
    let modalModels: [OverallModalCollectionViewCellModel] = [
        OverallModalCollectionViewCellModel(
            title: "첫 번째 모달",
            description: "이것은 첫 번째 모달",
            image: UIImage(systemName: "star.fill") ?? UIImage()
        ),
        OverallModalCollectionViewCellModel(
            title: "두 번째 모달",
            description: "이것은 두 번째 모달",
            image: UIImage(systemName: "heart.fill") ?? UIImage()
        ),
        OverallModalCollectionViewCellModel(
            title: "세 번째 모달",
            description: "이것은 세 번째 모달입니다.",
            image: UIImage(systemName: "circle.fill") ?? UIImage()
        )
    ]
    let cellModel = OverallCollectionViewCellModel(title: "종합 운세", modal: modalModels)
    
    cell.update(with: cellModel)
    containerView.backgroundColor = STColors.primary7.color

    containerView.addSubview(cell)
    cell.snp.makeConstraints { make in
        make.top.leading.trailing.bottom.equalToSuperview()
        make.height.equalTo(195)
    }
    
    return containerView
}
