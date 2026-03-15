//
//  RankPlaceViewController.swift
//  FeatureLayer
//
//  Created by 최재혁 on 3/12/26.
//

import Foundation
import UIKit
import Base
import DesignSystem

public final class RankPlaceViewController: BaseViewController {
  enum Region: String, CaseIterable {
    case all = "전국"
    case seoul = "서울"
    case gyeonggi = "경기"
    case incheon = "인천"
  }
  
  private let viewModel: RankViewModel
  private var buttons: [Region: UIButton] = [:]
  private let regions: [Region] = [.all, .seoul, .gyeonggi, .incheon]
  
  private lazy var dateLabel = UILabel().then {
    $0.style = Typography.Caption_12_M
    $0.textColor = STColors.gray4.color
  }
  
  private lazy var placeButtonStackView = UIStackView().then {
    $0.axis = .horizontal
    $0.spacing = 8
    $0.alignment = .center
  }
  
  private lazy var collectionView = UICollectionView(
    frame: .zero, collectionViewLayout: createLayout()
  ).then {
    $0.backgroundColor = .clear
    $0.showsVerticalScrollIndicator = false
    $0.dataSource = self
    $0.register(
      RankPlaceCell.self,
      forCellWithReuseIdentifier: RankPlaceCell.typeName
    )
  }
  
  init(viewModel: RankViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    setButtons()
    setupUI()
    setupBind()
    viewModel.send(input: .viewDidLoad)
    self.setNavigationBarHidden(true)
  }
}

extension RankPlaceViewController {
  private func setButtons() {
    Region.allCases.forEach { region in
      let button = UIButton().then {
        let title = region.rawValue.set(
          style: Typography.Body_14_SB.color(STColors.primary5.color)
        )
        $0.setAttributedTitle(title, for: .normal)
        $0.layer.cornerRadius = 14
        $0.clipsToBounds = true
        $0.layer.borderWidth = 1
        $0.layer.borderColor = STColors.primary7.color.cgColor
        $0.backgroundColor = STColors.white.color
      }
      
      buttons.updateValue(button, forKey: region)
    }
  }
  
  private func setupUI() {
    view.addSubview(dateLabel)
    view.addSubview(placeButtonStackView)
    view.addSubview(collectionView)
    
    regions.forEach { region in
      let button = buttons[region]!
      button.snp.makeConstraints { make in
        make.height.equalTo(28)
        make.width.equalTo(48)
      }
      placeButtonStackView.addArrangedSubview(button)
    }
    
    dateLabel.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.leading.equalToSuperview().offset(24)
    }
    
    placeButtonStackView.snp.makeConstraints { make in
      make.top.equalTo(dateLabel.snp.bottom).offset(9)
      make.leading.equalToSuperview().offset(24)
    }
    
    collectionView.snp.makeConstraints { make in
      make.top.equalTo(placeButtonStackView.snp.bottom).offset(6)
      make.leading.trailing.equalToSuperview()
      make.bottom.equalToSuperview()
    }
    
    buttons[.all]?.backgroundColor = STColors.primary2.color
    buttons[.all]?.layer.borderColor = STColors.primary2.color.cgColor
    let selectedTitle = Region.all.rawValue.set(
      style: Typography.Body_14_SB.color(STColors.white.color)
    )
    buttons[.all]?.setAttributedTitle(selectedTitle, for: .normal)
  }
  
  private func setupBind() {
    buttons.forEach { region, button in
      button.tapPublisher
        .sink { [weak self] in
          guard let self = self else { return }
          self.selectRegion(region)
          self.viewModel.send(input: .selectRegion(region.rawValue))
        }
        .store(in: &cancellables)
    }
    
    viewModel.output.showPlaces
      .sink { [weak self] _ in
        guard let self = self else { return }
        self.collectionView.reloadData()
      }
      .store(in: &cancellables)
    
    viewModel.output.setDate
      .sink { [weak self] date in
        guard let self = self else { return }
        self.dateLabel.styledText = date
      }
      .store(in: &cancellables)
    
    viewModel.output.showLoading
      .sink { [weak self] isLoading in
        guard let self = self else { return }
        if isLoading {
          self.showLoading()
        } else {
          self.hideLoading()
        }
      }
      .store(in: &cancellables)
    
    viewModel.output.showError
      .sink { [weak self] retryAction in
        guard let self = self else { return }
        self.showErrorPopup {
          retryAction()
        }
      }
      .store(in: &cancellables)
  }
  
  private func selectRegion(_ selectedRegion: Region) {
    buttons.forEach { region, button in
      let isSelected = region == selectedRegion
          
      button.backgroundColor = isSelected
        ? STColors.primary2.color
        : STColors.white.color
      
      button.layer.borderColor = isSelected
        ? STColors.primary2.color.cgColor
        : STColors.primary7.color.cgColor
      
      let textColor = isSelected
        ? STColors.white.color
        : STColors.primary5.color
      
      let title = region.rawValue.set(
        style: Typography.Body_14_SB.color(textColor)
      )
      
      button.setAttributedTitle(title, for: .normal)
    }
  }
  
  private func createLayout() -> UICollectionViewCompositionalLayout {
    let layout = UICollectionViewCompositionalLayout { section, env in
      let item = NSCollectionLayoutItem(
        layoutSize: NSCollectionLayoutSize(
          widthDimension: .fractionalWidth(1.0),
          heightDimension: .estimated(108)
        )
      )

      let group = NSCollectionLayoutGroup.vertical(
        layoutSize: NSCollectionLayoutSize(
          widthDimension: .fractionalWidth(1.0),
          heightDimension: .estimated(108)
        ),
        subitems: [item]
      )

      let sectionLayout = NSCollectionLayoutSection(group: group)
      return sectionLayout
    }

    return layout
  }
}

extension RankPlaceViewController: UICollectionViewDataSource {
  public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return viewModel.getPlacesCount()
  }
  
  public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: RankPlaceCell.typeName,
      for: indexPath
    ) as? RankPlaceCell, let section = viewModel.getSection(at: indexPath.item) else { return UICollectionViewCell() }
    
    cell.delegate = self
    cell.update(with: section)
    return cell
  }
}

extension RankPlaceViewController: RankPlaceCellDelegate {
  func rankPlaceCellDidTap(_ model: RankPlaceCellModel) {
    print("Tapped cell with id: \(model.id), title: \(model.title)")
  }
}

@available(iOS 17.0, *)
#Preview {
  let viewModel = RankViewModel()
  let viewcontroller = RankPlaceViewController(viewModel: viewModel)
  
  return viewcontroller
}
