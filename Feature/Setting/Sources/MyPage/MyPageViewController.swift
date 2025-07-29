//
//  MyPageViewController.swift
//  Setting
//
//  Created by ttozzi on 7/26/25.
//

import DesignSystem
import SnapKit
import Then
import UIKit

enum MyPageSection: Int, CaseIterable {
  case profile
  case feedback
  case menu
}

struct MyPageMenuItem {
  let title: String
  let style: MyPageMenuCollectionViewCellModel.Style
}

final class MyPageViewController: UIViewController {
  
  private enum Constant {
    static let menuItemHeight: CGFloat = 48
    static let sectionSpacing: CGFloat = 12
  }

  private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout()).then {
    $0.register(MyProfileInfoCollectionViewCell.self, forCellWithReuseIdentifier: MyProfileInfoCollectionViewCell.typeName)
    $0.register(SendFeedbackCollectionViewCell.self, forCellWithReuseIdentifier: SendFeedbackCollectionViewCell.typeName)
    $0.register(MyPageMenuCollectionViewCell.self, forCellWithReuseIdentifier: MyPageMenuCollectionViewCell.typeName)
  }
  // TODO: 임시 - ViewModel
  private let profileCellModel = MyProfileInfoCollectionViewCellModel(
    nickname: "콩떡",
    gender: "여",
    birthDate: "1999-12-25",
    birthTime: "01:00 ~ 02:59"
  )
  private let feedbackCellModel = SendFeedbackCollectionViewCellModel(
    description: "더 나은 서비스를 위해,\n여러분의 목소리를 들려주세요",
    feedbackButtonTitle: "의견 보내기"
  )
  private let menuItems: [MyPageMenuItem] = [
    .init(title: "푸시알림", style: .icon(STImages.chevronRightS.image)),
    .init(title: "이용약관", style: .icon(STImages.chevronRightS.image)),
    .init(title: "개인정보 처리방침", style: .icon(STImages.chevronRightS.image)),
    .init(title: "앱 버전", style: .text("1.0.0"))
  ]
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }
  
  private func setupUI() {
    view.backgroundColor = STColors.primary9.color
    setupCollectionView()
  }
  
  private func setupCollectionView() {
    collectionView.backgroundColor = .clear
    collectionView.dataSource = self
    view.addSubview(collectionView)
    collectionView.snp.makeConstraints {
      $0.edges.equalToSuperview().inset(24)
    }
  }
  
  private func createLayout() -> UICollectionViewCompositionalLayout {
    let layout = UICollectionViewCompositionalLayout { [weak self] section, env in
      guard let sectionType = MyPageSection(rawValue: section) else {
        return nil
      }
      
      let itemHeight: NSCollectionLayoutDimension
      let groupHeight: NSCollectionLayoutDimension
      let itemCount: Int
      
      switch sectionType {
      case .profile:
        itemHeight = .fractionalHeight(1.0)
        groupHeight = .estimated(200)
        itemCount = 1
      case .feedback:
        itemHeight = .fractionalHeight(1.0)
        groupHeight = .estimated(126)
        itemCount = 1
      case .menu:
        let count = self?.menuItems.count ?? 0
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
      sectionLayout.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: Constant.sectionSpacing, trailing: 0)
      sectionLayout.interGroupSpacing = Constant.sectionSpacing
      
      let background = NSCollectionLayoutDecorationItem.background(elementKind: MyPageSectionBackgroundView.typeName)
      background.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: Constant.sectionSpacing, trailing: 0)
      sectionLayout.decorationItems = [background]
      
      return sectionLayout
    }
    
    layout.register(MyPageSectionBackgroundView.self, forDecorationViewOfKind: MyPageSectionBackgroundView.typeName)
    return layout
  }
}

extension MyPageViewController: UICollectionViewDataSource {
  public func numberOfSections(in collectionView: UICollectionView) -> Int {
    return MyPageSection.allCases.count
  }
  
  public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    switch MyPageSection(rawValue: section) {
    case .profile, .feedback:
      return 1
    case .menu:
      return menuItems.count
    default:
      return 0
    }
  }
  
  public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    switch MyPageSection(rawValue: indexPath.section) {
    case .profile:
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyProfileInfoCollectionViewCell.typeName, for: indexPath)
      if let cell = cell as? MyProfileInfoCollectionViewCell {
        cell.update(with: profileCellModel)
      }
      return cell
    case .feedback:
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SendFeedbackCollectionViewCell.typeName, for: indexPath)
      if let cell = cell as? SendFeedbackCollectionViewCell {
        cell.update(with: feedbackCellModel)
      }
      return cell
    case .menu:
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyPageMenuCollectionViewCell.typeName, for: indexPath)
      if let cell = cell as? MyPageMenuCollectionViewCell {
        let item = menuItems[indexPath.item]
        let model = MyPageMenuCollectionViewCellModel(style: item.style, title: item.title)
        cell.update(with: model)
      }
      return cell
    default:
      return UICollectionViewCell()
    }
  }
}

@available(iOS 17.0, *)
#Preview {
  MyPageViewController()
}

// TODO: 적절한 위치로
extension NSObject {
  static var typeName: String { String(describing: self) }
}
