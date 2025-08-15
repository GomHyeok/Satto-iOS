//
//  RecommendationDetailViewController.swift
//  Home
//
//  Created by ttozzi on 8/7/25.
//

import Base
import Combine
import DesignSystem
import UIKit

final class RecommendationDetailViewController: BaseViewController {

  private enum Constant {
    static let horizontalMargin: CGFloat = 20
    static let footerHeight: CGFloat = 104
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
    $0.contentInset.bottom = Constant.footerHeight
  }
  private lazy var footerView = RecommendationDetailFooterContainerView()
  private lazy var tooltipView = TooltipView().then {  // TODO: 노출 조건 확인
    $0.text = "결과가 나왔소! 번호 보러 오시오."
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
    setupNavigationBar()
    setupUI()
    setupBinding()
    updateFooterView()  // TODO: 임시
    viewModel.send(input: .viewDidLoad)
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()

    if let window = view.window {
      footerView.snp.updateConstraints { make in
        make.height.equalTo(Constant.footerHeight + window.safeAreaInsets.bottom)
      }
    }
  }

  private func setupNavigationBar() {
    title = "콩떡님의 로또 번호"  // TODO: username 확인 필요
    navigationBar.backgroundColor = STColors.primary9.color
    let backButtonItem = NaivgationBarButtonItem.back
    setNavigationBarLeftButtonItems(items: [
      backButtonItem
    ])
  }

  private func setupUI() {
    view.addSubview(collectionView)
    collectionView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
      $0.leading.trailing.bottom.equalToSuperview()
    }

    view.addSubview(footerView)
    footerView.snp.makeConstraints { make in
      make.horizontalEdges.equalToSuperview()
      make.bottom.equalToSuperview()
      make.height.equalTo(Constant.footerHeight)
    }

    view.addSubview(tooltipView)
    tooltipView.snp.makeConstraints { make in
      make.bottom.equalTo(footerView.snp.top).inset(16)
      make.width.equalToSuperview().inset(24)
      make.centerX.equalToSuperview()
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

  private func updateFooterView() {  // TODO: 상태에 따른 업데이트
    let showResultsButton = UIButton().then {
      $0.backgroundColor = STColors.primary2.color
      $0.layer.cornerRadius = 8
      let style = Typography.Body_16_B.color(STColors.white.color)
      let styledText = "결과 확인하기".set(style: style)
      $0.setAttributedTitle(styledText, for: .normal)
    }
    showResultsButton.snp.makeConstraints { make in
      make.height.equalTo(48)
    }
    footerView.update(buttons: [showResultsButton])
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
  let vc = RecommendationDetailViewController(viewModel: RecommendationDetailViewModel())
  return UINavigationController(rootViewController: vc)
}
