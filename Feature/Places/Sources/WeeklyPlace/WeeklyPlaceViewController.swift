//
//  WeeklyPlaceViewController.swift
//  FeatureLayer
//
//  Created by 최재혁 on 3/10/26.
//

import Foundation
import UIKit
import Base
import DesignSystem

public final class WeeklyPlaceViewController: BaseViewController {
  enum Constant {
    static let firstButtonTitle = "1등 배출점"
    static let secondButtonTitle = "2등 배출점"
  }
  
  private let viewModel: WeeklyPlaceViewModel
  
  private lazy var titleStackView = UIStackView().then {
    $0.axis = .horizontal
    $0.spacing = 6
    $0.alignment = .center
  }
  
  private lazy var roundLabel = UILabel().then {
    $0.style = Typography.Body_18_B
    $0.textColor = STColors.gray1.color
  }
  
  private lazy var dateLabel = UILabel().then {
    $0.style = Typography.Caption_12_M
    $0.textColor = STColors.gray4.color
  }
  
  private lazy var splitView = UIView().then {
    $0.backgroundColor = STColors.gray5.color
  }
  
  private lazy var firstPlaceChip = RoundSolidChip().then {
    $0.update(text: Constant.firstButtonTitle)
    $0.update(leftIcon: STImages.trophy1.image)
    $0.update(style: .primary)
    $0.isUserInteractionEnabled = false
  }
  
  private lazy var secondPlaceChip = RoundSolidChip().then {
    $0.update(text: Constant.secondButtonTitle)
    $0.update(leftIcon: STImages.trophy2.image)
    $0.update(style: .white)
    $0.isUserInteractionEnabled = false
  }
  
  private lazy var firstPlaceButton = UIButton()
  private lazy var secondPlaceButton = UIButton()
  
  private lazy var collectionView = UICollectionView(
    frame: .zero, collectionViewLayout: createLayout()
  ).then {
    $0.dataSource = self
    $0.register(
      WeeklyPlaceCell.self,
      forCellWithReuseIdentifier: WeeklyPlaceCell.typeName
    )
  }
  
  public init(viewModel: WeeklyPlaceViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    self.setNavigationBarHidden(true)
    setupUI()
    setupBind()
    viewModel.send(input: .viewDidLoad)
  }
}

extension WeeklyPlaceViewController {
  private func setupUI() {
    view.backgroundColor = .white
    view.addSubview(titleStackView)
    titleStackView.addArrangedSubview(roundLabel)
    titleStackView.addArrangedSubview(splitView)
    titleStackView.addArrangedSubview(dateLabel)
    view.addSubview(firstPlaceButton)
    view.addSubview(secondPlaceButton)
    firstPlaceButton.addSubview(firstPlaceChip)
    secondPlaceButton.addSubview(secondPlaceChip)
    view.addSubview(collectionView)
    
    titleStackView.snp.makeConstraints{ make in
      make.top.equalToSuperview()
      make.leading.trailing.equalToSuperview().inset(24)
      make.height.equalTo(54)
    }
    
    splitView.snp.makeConstraints { make in
      make.width.equalTo(1)
      make.height.equalTo(16)
    }
    
    firstPlaceButton.snp.makeConstraints { make in
      make.top.equalTo(titleStackView.snp.bottom).offset(10)
      make.leading.equalToSuperview().inset(24)
      make.height.equalTo(28)
      make.width.equalTo(98)
    }

    firstPlaceChip.snp.makeConstraints { make in
      make.edges.equalTo(firstPlaceButton)
    }
    
    secondPlaceButton.snp.makeConstraints { make in
      make.top.equalTo(titleStackView.snp.bottom).offset(10)
      make.leading.equalTo(firstPlaceButton.snp.trailing).offset(8)
      make.height.equalTo(28)
      make.width.equalTo(98)
    }
    
    secondPlaceChip.snp.makeConstraints { make in
      make.edges.equalTo(secondPlaceButton)
    }
    
    collectionView.snp.makeConstraints { make in
      make.top.equalTo(firstPlaceButton.snp.bottom).offset(20)
      make.leading.trailing.bottom.equalToSuperview()
    }
    
    applyShadow(to: secondPlaceChip)
  }
  
  private func setupBind() {
    firstPlaceButton.tapPublisher
      .sink { [weak self] in
        guard let self else { return }
        print("first button tapped")
        viewModel.send(input: .selectPlaceRank(1))
        applyShadow(to: secondPlaceChip)
        firstPlaceChip.update(style: .primary)
      }
      .store(in: &cancellables)
    
    secondPlaceButton.tapPublisher
      .sink { [weak self] in
        guard let self else { return }
        viewModel.send(input: .selectPlaceRank(2))
        applyShadow(to: firstPlaceChip)
        firstPlaceChip.update(style: .white)
        secondPlaceChip.update(style: .primary)
      }
      .store(in: &cancellables)
    
    viewModel.output.showPlaces
      .receive(on: RunLoop.main)
      .sink { [weak self ] _ in
        guard let self else { return }
        self.collectionView.reloadData()
      }
      .store(in: &cancellables)
    
    viewModel.output.setRoundAndDate
      .receive(on: RunLoop.main)
      .sink { [weak self] round, date in
        guard let self else { return }
        self.roundLabel.styledText = round
        self.dateLabel.styledText = date
      }
      .store(in: &cancellables)
  }
  
  private func createLayout() -> UICollectionViewCompositionalLayout {
    let layout = UICollectionViewCompositionalLayout { section, env in
      let item = NSCollectionLayoutItem(
        layoutSize: NSCollectionLayoutSize(
          widthDimension: .fractionalWidth(1.0),
          heightDimension: .estimated(80)
        )
      )

      let group = NSCollectionLayoutGroup.vertical(
        layoutSize: NSCollectionLayoutSize(
          widthDimension: .fractionalWidth(1.0),
          heightDimension: .estimated(80)
        ),
        subitems: [item]
      )

      let sectionLayout = NSCollectionLayoutSection(group: group)
      return sectionLayout
    }

    return layout
  }
  
  private func applyShadow(to chip: RoundSolidChip) {
    chip.layer.shadowColor = UIColor.black.cgColor
    chip.layer.shadowOpacity = 0.16
    chip.layer.shadowOffset = CGSize(width: 0, height: 2)
    chip.layer.shadowRadius = 2
    
    chip.layer.masksToBounds = false
  }
}

extension WeeklyPlaceViewController: UICollectionViewDataSource {
  public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return viewModel.getPlacesCount()
  }
  
  public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: WeeklyPlaceCell.typeName,
      for: indexPath
    ) as? WeeklyPlaceCell, let section = viewModel.getSection(at: indexPath.item) else { return UICollectionViewCell() }
    
    cell.delegate = self
    cell.update(with: section)
    
    return cell
  }
}

extension WeeklyPlaceViewController: WeeklyPlaceCellDelegate {
  func weeklyPlaceCellDidTap(_ cellModel: WeeklyPlaceCellModel) {
    print("Tapped cell with id: \(cellModel.id), title: \(cellModel.title)")
  }
}

#if targetEnvironment(simulator)
  @available(iOS 17.0, *)
  #Preview {
    let viewModel = WeeklyPlaceViewModel()
    let weeklyPlaceViewController = WeeklyPlaceViewController(viewModel: viewModel)

    return weeklyPlaceViewController
  }
#endif
