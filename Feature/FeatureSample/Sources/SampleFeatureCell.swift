//
//  SampleFeatureCell.swift
//  FeatureLayer
//
//  Created by 최재혁 on 1/26/26.
//

import UIKit
import Then

struct SampleFeature {
  let title: String
  let viewControllerProvider: () -> UIViewController
}

final class SampleFeatureCell: UICollectionViewCell {

  static let identifier = "SampleFeatureCell"

  private let titleLabel = UILabel().then {
    $0.font = UIFont.systemFont(ofSize: 16, weight: .medium)
    $0.textColor = .black
    $0.translatesAutoresizingMaskIntoConstraints = false
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupView() {
    contentView.backgroundColor = .clear
    contentView.layer.borderColor = UIColor.lightGray.cgColor
    contentView.layer.borderWidth = 1.0
    contentView.clipsToBounds = true
    contentView.addSubview(titleLabel)

    NSLayoutConstraint.activate([
      titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
      titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
    ])
  }

  func configure(title: String) {
    titleLabel.text = title
  }
}
