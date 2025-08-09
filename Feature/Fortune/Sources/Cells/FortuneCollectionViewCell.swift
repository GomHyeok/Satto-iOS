//
//  FortuneCollectionViewCell.swift
//  FeatureLayer
//
//  Created by 최재혁 on 8/8/25.
//

import DesignSystem
import SnapKit
import Then
import UIKit

struct FortuneCollectionViewCellModel {
  let dayInfo: String?
  let scoreInfo: String?
  let fortuneImage: UIImage?
  let fortuneText: String?
}

final class FortuneCollectionViewCell: UICollectionViewCell {

  private lazy var contentStackView = UIStackView().then {
    $0.axis = .vertical
    $0.spacing = 6
  }

  private lazy var scoreStack = UIStackView().then {
    $0.axis = .vertical
    $0.spacing = 12
  }

}
