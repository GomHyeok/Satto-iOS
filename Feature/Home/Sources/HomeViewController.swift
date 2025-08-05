//
//  HomeViewController.swift
//  Home
//
//  Created by ttozzi on 7/31/25.
//

import Combine
import DesignSystem
import UIKit

final class HomeViewController: UIViewController {

  private enum Constant {
    static let horizontalMargin: CGFloat = 20
  }

  private lazy var collectionView = UICollectionView(
    frame: .zero, collectionViewLayout: createLayout()
  ).then {
    $0.backgroundColor = STColors.primary8.color  // TODO: 확인 필요
    $0.dataSource = self
    $0.register(
      HomeHeaderCollectionViewCell.self,
      forCellWithReuseIdentifier: HomeHeaderCollectionViewCell.typeName
    )
    $0.register(
      HomeRecommendationCollectionViewCell.self,
      forCellWithReuseIdentifier: HomeRecommendationCollectionViewCell.typeName
    )
    $0.register(
      HomeTodayFortuneCollectionViewCell.self,
      forCellWithReuseIdentifier: HomeTodayFortuneCollectionViewCell.typeName
    )
  }

  private let viewModel: HomeViewModel
  private var cancellables = Set<AnyCancellable>()

  init(viewModel: HomeViewModel) {
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
          heightDimension: .estimated(510)
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
      sectionLayout.interGroupSpacing = 12
      sectionLayout.contentInsets = NSDirectionalEdgeInsets(
        top: 28,
        leading: Constant.horizontalMargin,
        bottom: 34,
        trailing: Constant.horizontalMargin
      )
      return sectionLayout
    }
    return layout
  }
}

extension HomeViewController: UICollectionViewDataSource {

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
    case let item as HomeHeaderCollectionViewCellModel:
      let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: HomeHeaderCollectionViewCell.typeName,
        for: indexPath
      )
      if let cell = cell as? HomeHeaderCollectionViewCell {
        cell.update(with: item)
      }
      return cell

    case let item as HomeRecommendationCollectionViewCellModel:
      let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: HomeRecommendationCollectionViewCell.typeName,
        for: indexPath
      )
      if let cell = cell as? HomeRecommendationCollectionViewCell {
        cell.update(with: item)
      }
      return cell

    case let item as HomeTodayFortuneCollectionViewCellModel:
      let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: HomeTodayFortuneCollectionViewCell.typeName,
        for: indexPath
      )
      if let cell = cell as? HomeTodayFortuneCollectionViewCell {
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
  HomeViewController(viewModel: HomeViewModel())
}
