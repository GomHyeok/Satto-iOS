//
//  RecommendationDetailViewController.swift
//  Home
//
//  Created by ttozzi on 8/7/25.
//

import Combine
import DesignSystem
import UIKit

final class RecommendationDetailViewController: UIViewController {
  
  private enum Constant {
    static let horizontalMargin: CGFloat = 20
  }
  
  private lazy var collectionView = UICollectionView(
    frame: .zero, collectionViewLayout: createLayout()
  ).then {
    $0.backgroundColor = STColors.primary9.color
    $0.dataSource = self
    $0.register(
      NumberRecommendationCollectionViewCell.self,
      forCellWithReuseIdentifier: NumberRecommendationCollectionViewCell.typeName
    )
    $0.register(
      AIAnalysisResultCollectionViewCell.self,
      forCellWithReuseIdentifier: AIAnalysisResultCollectionViewCell.typeName
    )
    $0.register(
      DescriptionListCollectionViewCell.self,
      forCellWithReuseIdentifier: DescriptionListCollectionViewCell.typeName
    )
    $0.register(
      AvoidNumberCollectionViewCell.self,
      forCellWithReuseIdentifier: AvoidNumberCollectionViewCell.typeName
    )
  }
  
  private let viewModel: RecommendationDetailViewModel
  private var cancellables = Set<AnyCancellable>()

  init(viewModel: RecommendationDetailViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    setupBinding()
    viewModel.send(input: .viewDidLoad)
  }
  
  private func setupUI() {
    view.addSubview(collectionView)
    collectionView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
  
  private func setupBinding() {
    viewModel.output.sections
      .receive(on: DispatchQueue.main)
      .sink { [weak self] _ in
        self?.collectionView.reloadData()
      }
      .store(in: &cancellables)
  }

  private func createLayout() -> UICollectionViewCompositionalLayout {
    let layout = UICollectionViewCompositionalLayout { section, env in
      let item = NSCollectionLayoutItem(
        layoutSize: NSCollectionLayoutSize(
          widthDimension: .fractionalWidth(1.0),
          heightDimension: .estimated(329)
        )
      )

      let group = NSCollectionLayoutGroup.vertical(
        layoutSize: NSCollectionLayoutSize(
          widthDimension: .fractionalWidth(1.0),
          heightDimension: .estimated(1200)
        ),
        subitems: [item]
      )

      let sectionLayout = NSCollectionLayoutSection(group: group)
      sectionLayout.interGroupSpacing = 32
      sectionLayout.contentInsets = NSDirectionalEdgeInsets(
        top: .zero,
        leading: Constant.horizontalMargin,
        bottom: 45,
        trailing: Constant.horizontalMargin
      )
      return sectionLayout
    }
    return layout
  }
}

extension RecommendationDetailViewController: UICollectionViewDataSource {

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int)
    -> Int
  {
    return viewModel.output.sections.value.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)
    -> UICollectionViewCell
  {
    guard let item = viewModel.output.sections.value[safe: indexPath.item] else {
      return UICollectionViewCell()
    }
    switch item {
    case let item as NumberRecommendationCollectionViewCellModel:
      let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: NumberRecommendationCollectionViewCell.typeName,
        for: indexPath
      )
      if let cell = cell as? NumberRecommendationCollectionViewCell {
        cell.update(with: item)
      }
      return cell

    case let item as AIAnalysisResultCollectionViewCellModel:
      let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: AIAnalysisResultCollectionViewCell.typeName,
        for: indexPath
      )
      if let cell = cell as? AIAnalysisResultCollectionViewCell {
        cell.update(with: item)
      }
      return cell

    case let item as DescriptionListCollectionViewCellModel:
      let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: DescriptionListCollectionViewCell.typeName,
        for: indexPath
      )
      if let cell = cell as? DescriptionListCollectionViewCell {
        cell.update(with: item)
      }
      return cell
      
    case let item as AvoidNumberCollectionViewCellModel:
      let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: AvoidNumberCollectionViewCell.typeName,
        for: indexPath
      )
      if let cell = cell as? AvoidNumberCollectionViewCell {
        cell.update(with: item)
      }
      return cell

    default:
      return UICollectionViewCell()
    }
  }
}

@available(iOS 17.0, *)
#Preview {
  RecommendationDetailViewController(viewModel: RecommendationDetailViewModel())
}
