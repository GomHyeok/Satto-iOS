//
//  PushSettingViewController.swift
//  Setting
//
//  Created by ttozzi on 7/31/25.
//

import Combine
import DesignSystem
import SnapKit
import Then
import UIKit

final class PushSettingViewController: UIViewController {

  private lazy var collectionView = UICollectionView(
    frame: .zero, collectionViewLayout: createLayout()
  ).then {
    $0.backgroundColor = .clear
    $0.dataSource = self
    $0.register(
      PushSettingImageCollectionViewCell.self,
      forCellWithReuseIdentifier: PushSettingImageCollectionViewCell.typeName)
    $0.register(
      PushSettingToggleCollectionViewCell.self,
      forCellWithReuseIdentifier: PushSettingToggleCollectionViewCell.typeName)
  }
  private let viewModel: PushSettingViewModel
  private var cancellables = Set<AnyCancellable>()

  init(viewModel: PushSettingViewModel) {
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
    view.backgroundColor = STColors.white.color

    view.addSubview(collectionView)
    collectionView.snp.makeConstraints { make in
      make.verticalEdges.equalToSuperview()
      make.horizontalEdges.equalToSuperview().inset(24)
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
          heightDimension: .estimated(56)
        )
      )

      let group = NSCollectionLayoutGroup.vertical(
        layoutSize: NSCollectionLayoutSize(
          widthDimension: .fractionalWidth(1.0),
          heightDimension: .estimated(230)
        ),
        subitems: [item]
      )

      let sectionLayout = NSCollectionLayoutSection(group: group)
      sectionLayout.interGroupSpacing = 12
      return sectionLayout
    }
    return layout
  }
}

extension PushSettingViewController: UICollectionViewDataSource {
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
    case let item as PushSettingImageCollectionViewCellModel:
      let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: PushSettingImageCollectionViewCell.typeName, for: indexPath)
      if let cell = cell as? PushSettingImageCollectionViewCell {
        cell.update(with: item)
      }
      return cell

    case let item as PushSettingToggleCollectionViewCellModel:
      let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: PushSettingToggleCollectionViewCell.typeName, for: indexPath)
      if let cell = cell as? PushSettingToggleCollectionViewCell {
        cell.update(with: item)
        cell.toggleChangedPublisher
          .sink { [weak self] isOn in
            self?.viewModel.send(input: .toggleChanged(isOn: isOn))
          }
          .store(in: &cell.cancellables)
      }
      return cell

    default:
      return UICollectionViewCell()
    }
  }
}

@available(iOS 17.0, *)
#Preview {
  PushSettingViewController(viewModel: PushSettingViewModel())
}
