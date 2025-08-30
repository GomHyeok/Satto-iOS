//
//  TimeRangeCell.swift
//  FeatureLayer
//
//  Created by 최재혁 on 7/27/25.
//

import DesignSystem
import SnapKit
import Then
import UIKit

class TimeRangeCell: UICollectionViewCell {
  static let identifier = "TimeRangeCell"

  private let timeLabel = UILabel().then {
    $0.style = Typography.Body_16_B
    $0.textColor = STColors.gray5.color
    $0.textAlignment = .center
  }

  override var isSelected: Bool {
    didSet {
      updateAppearance()
    }
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupView() {
    contentView.addSubview(timeLabel)
    timeLabel.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    contentView.layer.cornerRadius = 10  // 셀의 둥근 모서리
    updateAppearance()
  }

  func configure(with timeRange: String) {
    timeLabel.styledText = timeRange
  }

  private func updateAppearance() {
    if isSelected {
      contentView.backgroundColor = STColors.primary8.color
      timeLabel.textColor = STColors.primary2.color
    } else {
      contentView.backgroundColor = .clear  // 기본 배경색
      timeLabel.textColor = STColors.gray5.color
    }
  }
}
