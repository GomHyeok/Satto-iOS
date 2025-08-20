//
//  FortuneViewController.swift
//  FeatureLayer
//
//  Created by 최재혁 on 8/8/25.
//

import Base
import Combine
import DesignSystem
import Then
import UIKit

enum FortuneSection {
  case fortune(FortuneCollectionViewCellModel)
  case overall(OverallCollectionViewCellModel)
  case thumbnail(ThumbnailCollectionViewCellModel)
  case moreInfo
}

public final class FortuneViewController: BaseViewController {

  private let viewModel: FortuneViewModel

  private lazy var ellips = UIImageView().then {
    $0.image = STImages.ellipseBackground.image.withRenderingMode(.alwaysTemplate)
    $0.contentMode = .scaleAspectFill
    $0.tintColor = STColors.primary8.color
  }

  private lazy var separteLine = UIImageView().then {
    $0.image = STImages.exportImage.image.withRenderingMode(.alwaysTemplate)
    $0.contentMode = .scaleAspectFill
    $0.tintColor = STColors.primary8.color
  }

  private lazy var backgroundView = UIView().then {
    $0.backgroundColor = STColors.primary8.color
  }

  private lazy var collectionView = UICollectionView(
    frame: .zero, collectionViewLayout: createLayout()
  ).then {
    $0.backgroundColor = .clear
    $0.dataSource = self
    $0.delegate = self
    $0.register(
      FortuneCollectionViewCell.self,
      forCellWithReuseIdentifier: FortuneCollectionViewCell.typeName
    )
    $0.register(
      OverallCollectionViewCell.self,
      forCellWithReuseIdentifier: OverallCollectionViewCell.typeName
    )
    $0.register(
      ThumbnailCollectionViewCell.self,
      forCellWithReuseIdentifier: ThumbnailCollectionViewCell.typeName
    )
    $0.register(
      MoreInfoCollectionViewCell.self,
      forCellWithReuseIdentifier: MoreInfoCollectionViewCell.typeName
    )
  }

  public init(viewModel: FortuneViewModel = FortuneViewModel()) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public override func viewDidLoad() {
    super.viewDidLoad()
    setNavigationBarHidden(false)
    setNavigationBarLeftButtonItems(items: [NavigationImageItem.logo])

    setupBinding()
    setupHierarchy()
    setupUI()

    viewModel.send(input: .viewDidLoad)
  }
}

// MARK: func
extension FortuneViewController {
  private func createLayout() -> UICollectionViewCompositionalLayout {
    let layout = UICollectionViewCompositionalLayout { [weak self] section, env in
      guard let self, let section = self.viewModel.output.sections.value[safe: section]
      else { return nil }

      let itemHeight: NSCollectionLayoutDimension
      let groupHeight: NSCollectionLayoutDimension
      let spacing: CGFloat

      switch section {
      case .fortune:
        itemHeight = .fractionalHeight(1.0)
        groupHeight = .estimated(218)
        spacing = 62
      case .overall:
        itemHeight = .fractionalHeight(1.0)
        groupHeight = .estimated(175)
        spacing = 32
      case .thumbnail:
        itemHeight = .fractionalHeight(1.0)
        groupHeight = .estimated(525)
        spacing = 32
      case .moreInfo:
        itemHeight = .fractionalHeight(1.0)
        groupHeight = .estimated(291)
        spacing = 32
      }

      let item = NSCollectionLayoutItem(
        layoutSize: NSCollectionLayoutSize(
          widthDimension: .fractionalWidth(1.0),
          heightDimension: itemHeight
        )
      )

      let group = NSCollectionLayoutGroup.vertical(
        layoutSize: NSCollectionLayoutSize(
          widthDimension: .fractionalWidth(1.0),
          heightDimension: groupHeight
        ),
        repeatingSubitem: item,
        count: 1
      )

      let sectionLayout = NSCollectionLayoutSection(group: group)
      sectionLayout.contentInsets = NSDirectionalEdgeInsets(
        top: 0, leading: 0, bottom: spacing, trailing: 0)

      return sectionLayout
    }

    return layout
  }
}

// MARK: SetupFunc
extension FortuneViewController {
  private func setupHierarchy() {
    self.view.addSubview(separteLine)
    self.view.addSubview(backgroundView)
    self.view.addSubview(ellips)
    self.view.addSubview(collectionView)
  }

  private func setupUI() {
    self.view.backgroundColor = STColors.primary9.color

    ellips.snp.makeConstraints { make in
      make.top.trailing.equalToSuperview()
      make.width.height.equalTo(264)
    }

    separteLine.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview()
      make.top.equalToSuperview().inset(360)
      make.height.equalTo(16)
    }

    backgroundView.snp.makeConstraints { make in
      make.leading.trailing.bottom.equalToSuperview()
      make.top.equalTo(separteLine.snp.bottom)
    }

    collectionView.snp.makeConstraints { make in
      make.top.equalTo(self.view.safeAreaLayoutGuide)
      make.bottom.equalTo(self.view.safeAreaLayoutGuide)
      make.leading.trailing.equalToSuperview()
    }
  }

  private func setupBinding() {
    viewModel.output.sections
      .receive(on: DispatchQueue.main)
      .sink { [weak self] _ in
        guard let self else { return }
        self.collectionView.reloadData()
      }
      .store(in: &cancellables)

    viewModel.output.isLoading
      .receive(on: DispatchQueue.main)
      .sink { [weak self] isLoading in
        guard let self else { return }
        if isLoading {
          self.showLoading()
        } else {
          self.hideLoading()
        }
      }
      .store(in: &cancellables)
    
    viewModel.output.showError
      .receive(on: DispatchQueue.main)
      .sink { [weak self] retryAction in
        guard let self else { return }
        self.showErrorPopup(action: retryAction)
      }
      .store(in: &cancellables)
  }
}

extension FortuneViewController: UICollectionViewDataSource, UICollectionViewDelegate {

  public func numberOfSections(in collectionView: UICollectionView) -> Int {
    return viewModel.output.sections.value.count
  }

  public func collectionView(
    _ collectionView: UICollectionView, numberOfItemsInSection section: Int
  )
    -> Int
  {
    return 1
  }

  public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)
    -> UICollectionViewCell
  {
    guard let section = viewModel.output.sections.value[safe: indexPath.section] else {
      return UICollectionViewCell()
    }

    switch section {
    case .fortune(let model):
      let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: FortuneCollectionViewCell.typeName,
        for: indexPath
      )
      if let cell = cell as? FortuneCollectionViewCell {
        cell.update(with: model)
      }
      return cell

    case .overall(let model):
      let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: OverallCollectionViewCell.typeName,
        for: indexPath
      )
      if let cell = cell as? OverallCollectionViewCell {
        cell.update(with: model)
      }
      return cell

    case .thumbnail(let model):
      let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: ThumbnailCollectionViewCell.typeName,
        for: indexPath
      )
      if let cell = cell as? ThumbnailCollectionViewCell {
        cell.update(with: model)
      }
      return cell

    case .moreInfo:
      let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: MoreInfoCollectionViewCell.typeName,
        for: indexPath
      )
      return cell
    }
  }
}

#if targetEnvironment(simulator)
  import DIInjector

  @available(iOS 17.0, *)
  #Preview {
    DependencyInjector.shared.assemble([
      FortuneAssembly()
    ])
    return FortuneViewController(viewModel: FortuneViewModel())
  }
#endif
