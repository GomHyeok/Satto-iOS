//
//  MyPageViewController.swift
//  Setting
//
//  Created by ttozzi on 7/26/25.
//

import Base
import Combine
import DesignSystem
import Extension
import SnapKit
import Then
import UIKit

enum MyPageSection {
  case profile(MyProfileInfoCollectionViewCellModel)
  case feedback(SendFeedbackCollectionViewCellModel)
  case menu([MyPageMenuCollectionViewCellModel])
}

public final class MyPageViewController: BaseViewController {

  private enum Constant {
    static let menuItemHeight: CGFloat = 48
    static let sectionSpacing: CGFloat = 12
  }

  private lazy var collectionView = UICollectionView(
    frame: .zero, collectionViewLayout: createLayout()
  ).then {
    $0.backgroundColor = .clear
    $0.dataSource = self
    $0.delegate = self
    $0.register(
      MyProfileInfoCollectionViewCell.self,
      forCellWithReuseIdentifier: MyProfileInfoCollectionViewCell.typeName)
    $0.register(
      SendFeedbackCollectionViewCell.self,
      forCellWithReuseIdentifier: SendFeedbackCollectionViewCell.typeName)
    $0.register(
      MyPageMenuCollectionViewCell.self,
      forCellWithReuseIdentifier: MyPageMenuCollectionViewCell.typeName)
  }
  private let viewModel: MyPageViewModel

  public init(viewModel: MyPageViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    setupBinding()
    viewModel.send(input: .viewDidLoad)
  }

  public override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

  }

  public override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

  }

  private func setupUI() {
    view.backgroundColor = STColors.primary9.color

    view.addSubview(collectionView)
    collectionView.snp.makeConstraints {
      $0.edges.equalToSuperview().inset(24)
    }
  }

  private func setupBinding() {
    viewModel.output.sections
      .receive(on: DispatchQueue.main)
      .sink { [weak self] _ in
        self?.collectionView.reloadData()
      }
      .store(in: &cancellables)

    viewModel.output.showToadt
      .receive(on: DispatchQueue.main)
      .sink { [weak self] in
        guard let self else { return }
        let toast = Toast().then {
          $0.update(message: "프로필 수정이 완료됐소.")
        }

        guard let tabBar = self.tabBarController?.view else { return }
        tabBar.addSubview(toast)
        toast.snp.makeConstraints { make in
          make.bottom.equalToSuperview().offset(-72)
          make.leading.equalToSuperview().offset(24)
          make.trailing.equalToSuperview().offset(-24)
          make.height.equalTo(44)
        }

        UIView.animate(
          withDuration: 0.5, delay: 3, options: .curveEaseOut,
          animations: {
            toast.alpha = 0.0
          },
          completion: { _ in
            toast.removeFromSuperview()
          })
      }
      .store(in: &cancellables)
  }

  private func createLayout() -> UICollectionViewCompositionalLayout {
    let layout = UICollectionViewCompositionalLayout { [weak self] section, env in
      guard let self,
        let section = self.viewModel.output.sections.value[safe: section]
      else {
        return nil
      }
      let itemHeight: NSCollectionLayoutDimension
      let groupHeight: NSCollectionLayoutDimension
      let itemCount: Int

      switch section {
      case .profile:
        itemHeight = .fractionalHeight(1.0)
        groupHeight = .estimated(200)
        itemCount = 1
      case .feedback:
        itemHeight = .fractionalHeight(1.0)
        groupHeight = .estimated(130)
        itemCount = 1
      case .menu(let items):
        let count = items.count
        itemHeight = .absolute(Constant.menuItemHeight)
        groupHeight = .estimated(Constant.menuItemHeight * CGFloat(max(count, 1)))
        itemCount = count
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
        count: max(itemCount, 1)
      )

      let sectionLayout = NSCollectionLayoutSection(group: group)
      sectionLayout.contentInsets = NSDirectionalEdgeInsets(
        top: 0, leading: 0, bottom: Constant.sectionSpacing, trailing: 0)
      sectionLayout.interGroupSpacing = Constant.sectionSpacing

      let background = NSCollectionLayoutDecorationItem.background(
        elementKind: MyPageSectionBackgroundView.typeName)
      background.contentInsets = NSDirectionalEdgeInsets(
        top: 0, leading: 0, bottom: Constant.sectionSpacing, trailing: 0)
      sectionLayout.decorationItems = [background]

      return sectionLayout
    }

    layout.register(
      MyPageSectionBackgroundView.self,
      forDecorationViewOfKind: MyPageSectionBackgroundView.typeName)
    return layout
  }
}

extension MyPageViewController: UICollectionViewDataSource {
  public func numberOfSections(in collectionView: UICollectionView) -> Int {
    return viewModel.output.sections.value.count
  }

  public func collectionView(
    _ collectionView: UICollectionView, numberOfItemsInSection section: Int
  )
    -> Int
  {
    guard let selectedSection = viewModel.output.sections.value[safe: section] else {
      return .zero
    }
    switch selectedSection {
    case .profile, .feedback:
      return 1
    case .menu(let items):
      return items.count
    }
  }

  public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)
    -> UICollectionViewCell
  {
    guard let section = viewModel.output.sections.value[safe: indexPath.section] else {
      return UICollectionViewCell()
    }

    switch section {
    case .profile(let model):
      let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: MyProfileInfoCollectionViewCell.typeName, for: indexPath)
      if let cell = cell as? MyProfileInfoCollectionViewCell {
        cell.update(with: model)
        cell.editButton.tapPublisher
          .sink { [weak self] in
            self?.viewModel.send(input: .editButtonTapped)
          }
          .store(in: &cell.cancellables)
      }
      return cell

    case .feedback(let model):
      let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: SendFeedbackCollectionViewCell.typeName, for: indexPath)
      if let cell = cell as? SendFeedbackCollectionViewCell {
        cell.update(with: model)
      }
      return cell

    case .menu(let models):
      let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: MyPageMenuCollectionViewCell.typeName, for: indexPath)
      if let cell = cell as? MyPageMenuCollectionViewCell {
        let model = models[indexPath.item]
        cell.update(with: model)
      }
      return cell
    }
  }
}

extension MyPageViewController: UICollectionViewDelegateFlowLayout {
  public func collectionView(
    _ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath
  ) {
    guard let section = viewModel.output.sections.value[safe: indexPath.section] else { return }
    switch section {
    case .profile:
      break

    case .feedback:
      viewModel.send(input: .feedBackButtonTapped)

    case .menu(let items):
      let item = items[indexPath.item]
      viewModel.send(input: .menuTapped(item: item))
    }
  }
}

#if targetEnvironment(simulator)
  import Auth
  import DIInjector
  import NetworkCore

  @available(iOS 17.0, *)
  #Preview {
    DependencyInjector.shared.assemble([
      AuthAssembly(),
      SettingAssembly(),
      NetworkCoreAssembly(),
    ])

    return MyPageViewController(viewModel: MyPageViewModel())
  }
#endif
